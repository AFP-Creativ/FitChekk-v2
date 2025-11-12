import XCTest
@testable import FitChekk

@MainActor
final class PortkeyServiceTests: XCTestCase {
    var mockSession: MockURLSession!
    var service: PortkeyService!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        service = PortkeyService(
            apiKey: "test-api-key",
            baseURL: "https://api.portkey.ai/v1",
            session: mockSession
        )
    }
    
    override func tearDown() {
        mockSession = nil
        service = nil
        super.tearDown()
    }
    
    // MARK: - Gemini Request Tests
    
    func testSendGeminiRequestSuccess() async throws {
        // Given
        let mockResponse = """
        {
            "choices": [{
                "message": {
                    "content": "{\\"category\\": \\"tops\\", \\"confidence\\": 0.95}"
                }
            }],
            "usage": {
                "prompt_tokens": 100,
                "completion_tokens": 50,
                "total_tokens": 150
            }
        }
        """
        mockSession.mockData = mockResponse.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.portkey.ai/v1/chat/completions")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let result = try await service.sendGeminiRequest(
            prompt: "Categorize this item",
            imageData: nil
        )
        
        // Then
        XCTAssertEqual(result, "{\"category\": \"tops\", \"confidence\": 0.95}")
        XCTAssertEqual(mockSession.lastRequest?.httpMethod, "POST")
        XCTAssertEqual(
            mockSession.lastRequest?.value(forHTTPHeaderField: "x-portkey-provider"),
            "google"
        )
    }
    
    func testSendGeminiRequestWithImage() async throws {
        // Given
        let mockResponse = """
        {
            "choices": [{
                "message": {
                    "content": "{\\"category\\": \\"tops\\"}"
                }
            }]
        }
        """
        mockSession.mockData = mockResponse.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.portkey.ai/v1/chat/completions")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let imageData = "test-image".data(using: .utf8)!
        
        // When
        let result = try await service.sendGeminiRequest(
            prompt: "Categorize this item",
            imageData: imageData
        )
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(mockSession.lastRequest?.value(forHTTPHeaderField: "x-portkey-provider"), "google")
    }
    
    // MARK: - Claude Request Tests
    
    func testSendClaudeRequestSuccess() async throws {
        // Given
        let mockResponse = """
        {
            "choices": [{
                "message": {
                    "content": "{\\"outfits\\": []}"
                }
            }]
        }
        """
        mockSession.mockData = mockResponse.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.portkey.ai/v1/chat/completions")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let result = try await service.sendClaudeRequest(
            systemPrompt: "You are a stylist",
            userPrompt: "Suggest an outfit"
        )
        
        // Then
        XCTAssertEqual(result, "{\"outfits\": []}")
        XCTAssertEqual(
            mockSession.lastRequest?.value(forHTTPHeaderField: "x-portkey-provider"),
            "anthropic"
        )
    }
    
    // MARK: - Error Handling Tests
    
    func testUnauthorizedError() async throws {
        // Given
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.portkey.ai/v1/chat/completions")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.mockData = "{}".data(using: .utf8)
        
        // When/Then
        do {
            _ = try await service.sendGeminiRequest(prompt: "Test")
            XCTFail("Should throw unauthorized error")
        } catch let error as PortkeyError {
            XCTAssertEqual(error, .unauthorized)
        }
    }
    
    func testRateLimitError() async throws {
        // Given
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.portkey.ai/v1/chat/completions")!,
            statusCode: 429,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.mockData = "{}".data(using: .utf8)
        
        // When/Then
        do {
            _ = try await service.sendGeminiRequest(prompt: "Test")
            XCTFail("Should throw rate limit error")
        } catch let error as PortkeyError {
            XCTAssertEqual(error, .rateLimitExceeded)
        }
    }
    
    func testServerError() async throws {
        // Given
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.portkey.ai/v1/chat/completions")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.mockData = "{}".data(using: .utf8)
        
        // When/Then
        do {
            _ = try await service.sendGeminiRequest(prompt: "Test")
            XCTFail("Should throw server error")
        } catch let error as PortkeyError {
            XCTAssertEqual(error, .serverError(500))
        }
    }
    
    func testInvalidRequestError() async throws {
        // Given
        let errorResponse = """
        {
            "error": {
                "message": "Invalid request parameters"
            }
        }
        """
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.portkey.ai/v1/chat/completions")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )
        mockSession.mockData = errorResponse.data(using: .utf8)
        
        // When/Then
        do {
            _ = try await service.sendGeminiRequest(prompt: "Test")
            XCTFail("Should throw invalid request error")
        } catch let error as PortkeyError {
            XCTAssertEqual(error, .invalidRequest("Invalid request parameters"))
        }
    }
    
    func testEmptyResponseError() async throws {
        // Given
        let mockResponse = """
        {
            "choices": []
        }
        """
        mockSession.mockData = mockResponse.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.portkey.ai/v1/chat/completions")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When/Then
        do {
            _ = try await service.sendGeminiRequest(prompt: "Test")
            XCTFail("Should throw empty response error")
        } catch let error as PortkeyError {
            XCTAssertEqual(error, .emptyResponse)
        }
    }
    
    // MARK: - Retry Logic Tests
    
    func testRetryOnNetworkError() async throws {
        // Given
        mockSession.shouldThrowError = true
        mockSession.errorToThrow = URLError(.networkConnectionLost)
        mockSession.maxAttemptsBeforeSuccess = 2
        
        let mockResponse = """
        {
            "choices": [{
                "message": {
                    "content": "success"
                }
            }]
        }
        """
        mockSession.mockData = mockResponse.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.portkey.ai/v1/chat/completions")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let result = try await service.sendGeminiRequest(prompt: "Test")
        
        // Then
        XCTAssertEqual(result, "success")
        XCTAssertEqual(mockSession.attemptCount, 3) // Failed twice, succeeded on third
    }
    
    func testRetryExhausted() async throws {
        // Given
        mockSession.shouldThrowError = true
        mockSession.errorToThrow = URLError(.networkConnectionLost)
        mockSession.maxAttemptsBeforeSuccess = 10 // More than max retries
        
        // When/Then
        do {
            _ = try await service.sendGeminiRequest(prompt: "Test")
            XCTFail("Should throw network error after retries exhausted")
        } catch let error as PortkeyError {
            if case .networkError = error {
                // Success - correct error type
            } else {
                XCTFail("Wrong error type: \(error)")
            }
        }
    }
    
    // MARK: - Request Headers Tests
    
    func testRequestHeaders() async throws {
        // Given
        let mockResponse = """
        {
            "choices": [{
                "message": {
                    "content": "test"
                }
            }]
        }
        """
        mockSession.mockData = mockResponse.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.portkey.ai/v1/chat/completions")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        _ = try await service.sendGeminiRequest(prompt: "Test")
        
        // Then
        let request = mockSession.lastRequest
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "x-portkey-api-key"), "test-api-key")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "x-portkey-provider"), "google")
    }
}

// MARK: - Mock URLSession

class MockURLSession: URLSession {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    var lastRequest: URLRequest?
    var shouldThrowError = false
    var errorToThrow: Error?
    var attemptCount = 0
    var maxAttemptsBeforeSuccess = 0
    
    override func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        lastRequest = request
        attemptCount += 1
        
        if shouldThrowError && attemptCount <= maxAttemptsBeforeSuccess {
            if let error = errorToThrow {
                throw error
            }
            throw URLError(.networkConnectionLost)
        }
        
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData, let response = mockResponse else {
            throw URLError(.badServerResponse)
        }
        
        return (data, response)
    }
}

