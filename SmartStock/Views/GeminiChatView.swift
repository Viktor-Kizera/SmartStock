import SwiftUI

struct GeminiMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct GeminiChatView: View {
    @State private var messages: [GeminiMessage] = []
    @State private var inputText: String = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 12) {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                    Image(systemName: "sparkles")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                Text("Gemini 2.0 Flash")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 6)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.13), Color.purple.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
            )
            Divider()
            // Chat body
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.text)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(22)
                                        .shadow(color: Color.blue.opacity(0.10), radius: 2, x: 0, y: 2)
                                        .frame(maxWidth: 260, alignment: .trailing)
                                } else {
                                    Text(message.text)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .background(Color.white)
                                        .foregroundColor(.primary)
                                        .cornerRadius(22)
                                        .shadow(color: Color.gray.opacity(0.08), radius: 1, x: 0, y: 1)
                                        .frame(maxWidth: 260, alignment: .leading)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                        if isLoading {
                            HStack {
                                ProgressView()
                                Text("Generating response...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .background(Color(.systemGray6))
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            // Input
            HStack(spacing: 10) {
                TextField("Type a message...", text: $inputText)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .cornerRadius(22)
                    .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                    .disabled(isLoading)
                    .frame(minHeight: 44)
                Button(action: sendMessage) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 44, height: 44)
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(inputText.isEmpty || isLoading ? 0.95 : 1.08)
                    .opacity(inputText.isEmpty || isLoading ? 0.5 : 1)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: inputText)
                }
                .disabled(inputText.isEmpty || isLoading)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.13), Color.purple.opacity(0.10)]), startPoint: .top, endPoint: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    func sendMessage() {
        let prompt = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prompt.isEmpty else { return }
        messages.append(GeminiMessage(text: prompt, isUser: true))
        inputText = ""
        isLoading = true
        sendToGemini(prompt: prompt) { response in
            DispatchQueue.main.async {
                if let text = response {
                    messages.append(GeminiMessage(text: text, isUser: false))
                } else {
                    messages.append(GeminiMessage(text: "Sorry, could not get a response.", isUser: false))
                }
                isLoading = false
            }
        }
    }
}

struct GeminiChatFloatingButton: View {
    @State private var showChat = false
    var body: some View {
        Button(action: { showChat = true }) {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 62, height: 62)
                    .shadow(color: Color.blue.opacity(0.25), radius: 8, x: 0, y: 4)
                Image(systemName: "message.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .accessibilityLabel("Open chatbot")
        .sheet(isPresented: $showChat) {
            GeminiChatView()
                .presentationDetents([.medium, .large])
        }
    }
}

// --- Gemini API ---

let GEMINI_API_KEY = "AIzaSyAouu3Jqc4BYDeI_31jBd-oAZVyTQsjDKQ"

func sendToGemini(prompt: String, completion: @escaping (String?) -> Void) {
    let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(GEMINI_API_KEY)"
    print("[Gemini] Endpoint: \(endpoint)")
    guard let url = URL(string: endpoint) else {
        print("[Gemini] Invalid URL")
        completion(nil)
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let body: [String: Any] = [
        "contents": [
            ["parts": [["text": prompt]]]
        ]
    ]
    if let bodyData = try? JSONSerialization.data(withJSONObject: body),
       let bodyString = String(data: bodyData, encoding: .utf8) {
        print("[Gemini] Request body: \(bodyString)")
    }
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    print("[Gemini] Sending request...")
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("[Gemini] Network error: \(error)")
            completion(nil)
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("[Gemini] Status code: \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                if let data = data, let body = String(data: data, encoding: .utf8) {
                    print("[Gemini] Response body: \(body)")
                }
                completion(nil)
                return
            }
        }
        guard let data = data else {
            print("[Gemini] No data received")
            completion(nil)
            return
        }
        if let jsonString = String(data: data, encoding: .utf8) {
            print("[Gemini] Raw JSON: \(jsonString)")
        }
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let content = candidates.first?["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let text = parts.first?["text"] as? String else {
            print("[Gemini] Failed to parse response")
            completion(nil)
            return
        }
        print("[Gemini] Success! Got response.")
        completion(text)
    }.resume()
} 
