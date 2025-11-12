import Foundation

// MARK: - Portkey Request/Response Models

struct PortkeyRequest: Encodable {
    let messages: [PortkeyMessage]
    let model: String
    let maxTokens: Int?
    let temperature: Double?
    
    enum CodingKeys: String, CodingKey {
        case messages, model
        case maxTokens = "max_tokens"
        case temperature
    }
}

struct PortkeyMessage: Encodable {
    let role: String
    let content: [PortkeyContent]
}

struct PortkeyContent: Encodable {
    let type: String
    let text: String?
    let imageUrl: PortkeyImageUrl?
    
    enum CodingKeys: String, CodingKey {
        case type, text
        case imageUrl = "image_url"
    }
}

struct PortkeyImageUrl: Encodable {
    let url: String
}

struct PortkeyResponse: Decodable {
    let choices: [PortkeyChoice]
    let usage: PortkeyUsage?
}

struct PortkeyChoice: Decodable {
    let message: PortkeyResponseMessage
}

struct PortkeyResponseMessage: Decodable {
    let content: String
}

struct PortkeyUsage: Decodable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

// MARK: - Portkey Service

/// Service for communicating with Portkey AI Gateway
final class PortkeyService: @unchecked Sendable {
    private let session: URLSession
    private let apiKey: String
    private let baseURL: URL
    
    init(
        apiKey: String? = nil,
        baseURL: String = "https://api.portkey.ai/v1",
        session: URLSession = .shared
    ) {
        // Try to load API key from Info.plist if not provided
        if let key = apiKey {
            self.apiKey = key
        } else if let key = Bundle.main.object(forInfoDictionaryKey: "PORTKEY_API_KEY") as? String {
            self.apiKey = key
        } else {
            fatalError("Portkey API key not found. Set PORTKEY_API_KEY in Info.plist or pass to init.")
        }
        
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid Portkey base URL: \(baseURL)")
        }
        
        self.baseURL = url
        self.session = session
    }
    
    // MARK: - Gemini Requests
    
    /// Send a request to Gemini via Portkey
    func sendGeminiRequest(
        prompt: String,
        imageData: Data? = nil,
        maxTokens: Int = 2048,
        temperature: Double = 0.7
    ) async throws -> String {
        var contents: [PortkeyContent] = []
        
        // Add text content
        contents.append(PortkeyContent(
            type: "text",
            text: prompt,
            imageUrl: nil
        ))
        
        // Add image if provided
        if let imageData = imageData {
            let base64Image = imageData.base64EncodedString()
            let dataUrl = "data:image/jpeg;base64,\(base64Image)"
            contents.append(PortkeyContent(
                type: "image_url",
                text: nil,
                imageUrl: PortkeyImageUrl(url: dataUrl)
            ))
        }
        
        let request = PortkeyRequest(
            messages: [
                PortkeyMessage(role: "user", content: contents)
            ],
            model: "gemini-1.5-flash",
            maxTokens: maxTokens,
            temperature: temperature
        )
        
        return try await sendRequest(
            request: request,
            provider: "google",
            virtualKey: nil
        )
    }
    
    // MARK: - Claude Requests
    
    /// Send a request to Claude via Portkey
    func sendClaudeRequest(
        systemPrompt: String,
        userPrompt: String,
        maxTokens: Int = 4096,
        temperature: Double = 0.7
    ) async throws -> String {
        let request = PortkeyRequest(
            messages: [
                PortkeyMessage(
                    role: "system",
                    content: [PortkeyContent(type: "text", text: systemPrompt, imageUrl: nil)]
                ),
                PortkeyMessage(
                    role: "user",
                    content: [PortkeyContent(type: "text", text: userPrompt, imageUrl: nil)]
                )
            ],
            model: "claude-sonnet-4-20250514",
            maxTokens: maxTokens,
            temperature: temperature
        )
        
        return try await sendRequest(
            request: request,
            provider: "anthropic",
            virtualKey: nil
        )
    }
    
    // MARK: - Private Helpers
    
    private func sendRequest(
        request: PortkeyRequest,
        provider: String,
        virtualKey: String?
    ) async throws -> String {
        let endpoint = baseURL.appendingPathComponent("chat/completions")
        
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-portkey-api-key")
        urlRequest.setValue(provider, forHTTPHeaderField: "x-portkey-provider")
        
        if let virtualKey = virtualKey {
            urlRequest.setValue(virtualKey, forHTTPHeaderField: "x-portkey-virtual-key")
        }
        
        // Encode request body
        let encoder = JSONEncoder()
        urlRequest.httpBody = try encoder.encode(request)
        
        // Send request with retry logic
        return try await sendWithRetry(urlRequest: urlRequest, maxRetries: 3)
    }
    
    private func sendWithRetry(
        urlRequest: URLRequest,
        maxRetries: Int,
        currentAttempt: Int = 0
    ) async throws -> String {
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw PortkeyError.invalidResponse
            }
            
            // Handle HTTP errors
            guard (200...299).contains(httpResponse.statusCode) else {
                throw mapHTTPError(statusCode: httpResponse.statusCode, data: data)
            }
            
            // Decode response
            let decoder = JSONDecoder()
            let portkeyResponse = try decoder.decode(PortkeyResponse.self, from: data)
            
            guard let firstChoice = portkeyResponse.choices.first else {
                throw PortkeyError.emptyResponse
            }
            
            return firstChoice.message.content
            
        } catch let error as PortkeyError {
            // Don't retry on client errors or rate limits
            throw error
        } catch {
            // Retry on network errors
            if currentAttempt < maxRetries {
                let delay = exponentialBackoff(attempt: currentAttempt)
                try await Task.sleep(nanoseconds: delay)
                return try await sendWithRetry(
                    urlRequest: urlRequest,
                    maxRetries: maxRetries,
                    currentAttempt: currentAttempt + 1
                )
            }
            throw PortkeyError.networkError(error.localizedDescription)
        }
    }
    
    private func exponentialBackoff(attempt: Int) -> UInt64 {
        let baseDelay: UInt64 = 1_000_000_000 // 1 second in nanoseconds
        let maxDelay: UInt64 = 10_000_000_000 // 10 seconds
        let delay = baseDelay * UInt64(pow(2.0, Double(attempt)))
        return min(delay, maxDelay)
    }
    
    private func mapHTTPError(statusCode: Int, data: Data) -> PortkeyError {
        switch statusCode {
        case 400:
            return .invalidRequest(parseErrorMessage(from: data))
        case 401:
            return .unauthorized
        case 429:
            return .rateLimitExceeded
        case 500...599:
            return .serverError(statusCode)
        default:
            return .httpError(statusCode)
        }
    }
    
    private func parseErrorMessage(from data: Data) -> String {
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let error = json["error"] as? [String: Any],
           let message = error["message"] as? String {
            return message
        }
        return "Unknown error"
    }
}

// MARK: - Errors

enum PortkeyError: Error, Equatable {
    case invalidRequest(String)
    case unauthorized
    case rateLimitExceeded
    case serverError(Int)
    case httpError(Int)
    case invalidResponse
    case emptyResponse
    case networkError(String)
    case decodingError
    
    static func == (lhs: PortkeyError, rhs: PortkeyError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRequest(let lhsMsg), .invalidRequest(let rhsMsg)):
            return lhsMsg == rhsMsg
        case (.unauthorized, .unauthorized):
            return true
        case (.rateLimitExceeded, .rateLimitExceeded):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        case (.httpError(let lhsCode), .httpError(let rhsCode)):
            return lhsCode == rhsCode
        case (.invalidResponse, .invalidResponse):
            return true
        case (.emptyResponse, .emptyResponse):
            return true
        case (.networkError(let lhsMsg), .networkError(let rhsMsg)):
            return lhsMsg == rhsMsg
        case (.decodingError, .decodingError):
            return true
        default:
            return false
        }
    }
}

extension PortkeyError {
    init(error: Error) {
        if let portkeyError = error as? PortkeyError {
            self = portkeyError
        } else {
            self = .networkError(error.localizedDescription)
        }
    }
}
