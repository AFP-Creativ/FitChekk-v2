//
//  AppleSignInManager.swift
//  FitChekk
//
//  Manager for handling Apple Sign-In flow
//

import AuthenticationServices
import Foundation

@MainActor
final class AppleSignInManager: NSObject,
                                ASAuthorizationControllerDelegate,
                                ASAuthorizationControllerPresentationContextProviding {
    private var continuation: CheckedContinuation<ASAuthorizationAppleIDCredential, Error>?

    func signIn() async throws -> ASAuthorizationAppleIDCredential {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }

    // MARK: - ASAuthorizationControllerDelegate

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AuthError.unknown)
            return
        }

        continuation?.resume(returning: appleIDCredential)
        continuation = nil
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let authError = error as? ASAuthorizationError {
            switch authError.code {
            case .canceled:
                continuation?.resume(throwing: AuthError.cancelled)
            case .unknown:
                continuation?.resume(throwing: AuthError.unknown)
            default:
                continuation?.resume(throwing: AuthError.unknown)
            }
        } else {
            continuation?.resume(throwing: error)
        }
        continuation = nil
    }

    // MARK: - ASAuthorizationControllerPresentationContextProviding

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Get the first window scene
        let activeScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive })

        guard let scene = activeScene as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            // Fallback to any window
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow } ?? UIWindow()
        }
        return window
    }
}
