import SwiftUI
import UIKit

struct USSDResultView: View {
    let profile: USSDProfile
    let style: DisplayStyle
    let onClose: () -> Void

    @State private var isLoading = true

    var body: some View {
        ZStack {
            Color(red: 0.35, green: 0.35, blue: 0.35)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if style == .styleA {
                    carrierBadge
                } else {
                    Spacer()
                        .frame(height: 14)
                }

                if isLoading {
                    Spacer()

                    VStack(spacing: 7) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                            .scaleEffect(1.05)

                        Text("Vui lòng đợi...")
                            .font(.system(size: 19, weight: .regular))
                            .foregroundStyle(.white)
                    }

                    Spacer()
                } else {
                    VStack(spacing: 0) {
                        Text(resultText)
                            .font(.system(size: style == .styleB ? 18 : 19, weight: .regular))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(style == .styleB ? 6 : 7)
                            .padding(.horizontal, style == .styleB ? 30 : 22)
                            .padding(.top, style == .styleB ? 120 : 72)

                        Spacer()
                    }

                    bottomButtons
                        .padding(.horizontal, 18)
                        .padding(.bottom, 22)
                }
            }
        }
        .onAppear {
            isLoading = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                withAnimation(.easeOut(duration: 0.18)) {
                    isLoading = false
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var carrierBadge: some View {
        Color.clear
            .frame(height: 24)
    }

    private var resultText: String {
        switch style {
        case .styleA:
            return """
            \(profile.phoneNumber). TKG: \(profile.mainBalance)d, dung den 0h
            \(profile.expiryDate).Chon:
            1. 50K/5ngay=6GB/ngay+Uu dai khac
            2. 20K/3ngay=6GB
            3. 10K/ngay=6GB
            """

        case .styleB:
            return """
            \(profile.phoneNumber). Zone+ . TKC \(profile.mainBalance) d, TK no 0VND,
            HSD: 00:00 \(profile.expiryDate). QK khong co TK Khuyen
            mai.
            """
        }
    }

    private var bottomButtons: some View {
        HStack(spacing: style == .styleA ? 10 : 0) {
            Button(action: onClose) {
                Text("Bỏ qua")
                    .font(.system(size: 25, weight: .regular))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 76)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .buttonStyle(.plain)

            if style == .styleA {
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Text("Trả lời")
                        .font(.system(size: 25, weight: .regular))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 76)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
