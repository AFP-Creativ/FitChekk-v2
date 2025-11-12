import XCTest
@testable import FitChekk

@MainActor
final class CategorizationServiceTests: XCTestCase {
    var mockPortkey: MockPortkeyService!
    var service: LiveCategorizationService!
    
    override func setUp() {
        super.setUp()
        mockPortkey = MockPortkeyService()
        service = LiveCategorizationService(portkeyService: mockPortkey)
    }
    
    override func tearDown() {
        mockPortkey = nil
        service = nil
        super.tearDown()
    }
    
    // MARK: - Successful Categorization Tests
    
    func testCategorizationSuccess() async throws {
        // Given
        let mockResponse = """
        {
            "category": "tops",
            "subCategory": "basic_tees",
            "colors": ["Blue", "Navy"],
            "pattern": "solid",
            "formality": 2,
            "seasons": ["spring", "summer", "fall"],
            "materialType": "cotton",
            "confidence": 0.92
        }
        """
        mockPortkey.mockGeminiResponse = mockResponse
        
        let testImage = UIImage.testImage().jpegData(compressionQuality: 0.8)!
        
        // When
        let result = try await service.categorizeItem(image: testImage)
        
        // Then
        XCTAssertEqual(result.category, .tops)
        XCTAssertEqual(result.subCategory, .basicTees)
        XCTAssertEqual(result.colors, ["Blue", "Navy"])
        XCTAssertEqual(result.pattern, "solid")
        XCTAssertEqual(result.formality, .casual)
        XCTAssertEqual(result.seasons.count, 3)
        XCTAssertEqual(result.materialType, "cotton")
        XCTAssertEqual(result.confidence, 0.92)
        XCTAssertFalse(result.needsHumanReview)
    }
    
    func testCategorizationHighConfidence() async throws {
        // Given
        let mockResponse = """
        {
            "category": "bottoms",
            "subCategory": "jeans",
            "colors": ["Blue"],
            "pattern": null,
            "formality": 2,
            "seasons": ["spring", "fall", "winter"],
            "materialType": "denim",
            "confidence": 0.95
        }
        """
        mockPortkey.mockGeminiResponse = mockResponse
        
        let testImage = UIImage.testImage().jpegData(compressionQuality: 0.8)!
        
        // When
        let result = try await service.categorizeItem(image: testImage)
        
        // Then
        XCTAssertEqual(result.confidence, 0.95)
        XCTAssertFalse(result.needsHumanReview)
        XCTAssertTrue(service.validateCategories(result))
    }
    
    func testCategorizationLowConfidence() async throws {
        // Given
        let mockResponse = """
        {
            "category": "accessories",
            "subCategory": "bags",
            "colors": ["Brown"],
            "pattern": null,
            "formality": 3,
            "seasons": ["spring", "summer", "fall", "winter"],
            "materialType": "leather",
            "confidence": 0.65
        }
        """
        mockPortkey.mockGeminiResponse = mockResponse
        
        let testImage = UIImage.testImage().jpegData(compressionQuality: 0.8)!
        
        // When
        let result = try await service.categorizeItem(image: testImage)
        
        // Then
        XCTAssertEqual(result.confidence, 0.65)
        XCTAssertTrue(result.needsHumanReview)
        XCTAssertFalse(service.validateCategories(result))
    }
    
    func testCategorizationWithMarkdownResponse() async throws {
        // Given - AI sometimes wraps JSON in markdown
        let mockResponse = """
        ```json
        {
            "category": "dresses",
            "subCategory": "casual_dresses",
            "colors": ["Red", "Pink"],
            "pattern": "floral",
            "formality": 2,
            "seasons": ["spring", "summer"],
            "materialType": "cotton",
            "confidence": 0.88
        }
        ```
        """
        mockPortkey.mockGeminiResponse = mockResponse
        
        let testImage = UIImage.testImage().jpegData(compressionQuality: 0.8)!
        
        // When
        let result = try await service.categorizeItem(image: testImage)
        
        // Then
        XCTAssertEqual(result.category, .dresses)
        XCTAssertEqual(result.subCategory, .casualDresses)
        XCTAssertEqual(result.confidence, 0.88)
    }
    
    // MARK: - Error Handling Tests
    
    func testInvalidImageError() async throws {
        // Given
        mockPortkey.shouldThrowError = true
        mockPortkey.errorToThrow = .invalidRequest("Invalid image format")
        
        let testImage = Data()
        
        // When/Then
        do {
            _ = try await service.categorizeItem(image: testImage)
            XCTFail("Should throw invalid image error")
        } catch let error as CategorizationError {
            XCTAssertEqual(error, .invalidImage)
        }
    }
    
    func testNetworkError() async throws {
        // Given
        mockPortkey.shouldThrowError = true
        mockPortkey.errorToThrow = .networkError("Connection failed")
        
        let testImage = UIImage.testImage().jpegData(compressionQuality: 0.8)!
        
        // When/Then
        do {
            _ = try await service.categorizeItem(image: testImage)
            XCTFail("Should throw network error")
        } catch let error as CategorizationError {
            XCTAssertEqual(error, .networkError)
        }
    }
    
    func testAPILimitReached() async throws {
        // Given
        mockPortkey.shouldThrowError = true
        mockPortkey.errorToThrow = .rateLimitExceeded
        
        let testImage = UIImage.testImage().jpegData(compressionQuality: 0.8)!
        
        // When/Then
        do {
            _ = try await service.categorizeItem(image: testImage)
            XCTFail("Should throw API limit error")
        } catch let error as CategorizationError {
            XCTAssertEqual(error, .apiLimitReached)
        }
    }
    
    func testProcessingFailed() async throws {
        // Given
        mockPortkey.shouldThrowError = true
        mockPortkey.errorToThrow = .serverError(500)
        
        let testImage = UIImage.testImage().jpegData(compressionQuality: 0.8)!
        
        // When/Then
        do {
            _ = try await service.categorizeItem(image: testImage)
            XCTFail("Should throw processing failed error")
        } catch let error as CategorizationError {
            XCTAssertEqual(error, .processingFailed)
        }
    }
    
    func testInvalidJSONResponse() async throws {
        // Given
        mockPortkey.mockGeminiResponse = "This is not valid JSON"
        
        let testImage = UIImage.testImage().jpegData(compressionQuality: 0.8)!
        
        // When/Then
        do {
            _ = try await service.categorizeItem(image: testImage)
            XCTFail("Should throw processing failed error")
        } catch let error as CategorizationError {
            XCTAssertEqual(error, .processingFailed)
        }
    }
    
    func testMissingRequiredField() async throws {
        // Given - Missing confidence field
        let mockResponse = """
        {
            "category": "tops",
            "subCategory": "basic_tees",
            "colors": ["Blue"],
            "pattern": null,
            "formality": 2,
            "seasons": ["spring"],
            "materialType": "cotton"
        }
        """
        mockPortkey.mockGeminiResponse = mockResponse
        
        let testImage = UIImage.testImage().jpegData(compressionQuality: 0.8)!
        
        // When/Then
        do {
            _ = try await service.categorizeItem(image: testImage)
            XCTFail("Should throw processing failed error")
        } catch let error as CategorizationError {
            XCTAssertEqual(error, .processingFailed)
        }
    }
    
    // MARK: - Multiple Categories Tests
    
    func testAllMainCategories() async throws {
        let categories: [(String, ItemCategory)] = [
            ("tops", .tops),
            ("bottoms", .bottoms),
            ("dresses", .dresses),
            ("outerwear", .outerwear),
            ("shoes", .shoes),
            ("accessories", .accessories)
        ]
        
        for (categoryString, expectedCategory) in categories {
            // Given
            let mockResponse = """
            {
                "category": "\(categoryString)",
                "subCategory": "\(getDefaultSubcategory(for: categoryString))",
                "colors": ["Black"],
                "pattern": "solid",
                "formality": 2,
                "seasons": ["spring"],
                "materialType": "unknown",
                "confidence": 0.85
            }
            """
            mockPortkey.mockGeminiResponse = mockResponse
            
            let testImage = UIImage.testImage().jpegData(compressionQuality: 0.8)!
            
            // When
            let result = try await service.categorizeItem(image: testImage)
            
            // Then
            XCTAssertEqual(result.category, expectedCategory)
        }
    }
    
    func testAllFormalityLevels() async throws {
        let formalityLevels = [1, 2, 3, 4, 5]
        
        for level in formalityLevels {
            // Given
            let mockResponse = """
            {
                "category": "tops",
                "subCategory": "basic_tees",
                "colors": ["Black"],
                "pattern": null,
                "formality": \(level),
                "seasons": ["spring"],
                "materialType": "cotton",
                "confidence": 0.85
            }
            """
            mockPortkey.mockGeminiResponse = mockResponse
            
            let testImage = UIImage.testImage().jpegData(compressionQuality: 0.8)!
            
            // When
            let result = try await service.categorizeItem(image: testImage)
            
            // Then
            XCTAssertEqual(result.formality.rawValue, level)
        }
    }
    
    // MARK: - Helper Methods
    
    private func getDefaultSubcategory(for category: String) -> String {
        switch category {
        case "tops": return "basic_tees"
        case "bottoms": return "jeans"
        case "dresses": return "casual_dresses"
        case "outerwear": return "jackets"
        case "shoes": return "sneakers"
        case "accessories": return "bags"
        default: return "basic_tees"
        }
    }
}

// MARK: - Mock Portkey Service

class MockPortkeyService {
    var mockGeminiResponse: String?
    var shouldThrowError = false
    var errorToThrow: PortkeyError?
    
    func sendGeminiRequest(
        prompt: String,
        imageData: Data?,
        maxTokens: Int,
        temperature: Double
    ) async throws -> String {
        if shouldThrowError, let error = errorToThrow {
            throw error
        }
        
        return mockGeminiResponse ?? "{}"
    }
}

// MARK: - UIImage Test Extension

extension UIImage {
    static func testImage() -> UIImage {
        // Create a simple 100x100 test image
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.blue.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

