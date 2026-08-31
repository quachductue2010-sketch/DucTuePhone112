import SwiftUI
import UIKit

struct DialKey: Identifiable, Hashable {
    let id = UUID()
    let value: String
    let letters: String
}

struct PhoneView: View {
    @AppStorage("phone101.phoneNumber") private var phoneNumber = "0900000000"
    @AppStorage("phone101.mainBalance") private var mainBalance = "10.000"
    @AppStorage("phone101.expiryDate") private var expiryDate = "31/12/2026"
    @AppStorage("phone101.displayStyle") private var selectedStyleRaw = DisplayStyle.styleA.rawValue

    @State private var dialed = ""
    @State private var showUSSD = false
    @State private var showUnsupported = false
    @State private var showStylePicker = false
    @State private var showProfileSettings = false

    private let rows: [[DialKey]] = [
        [.init(value: "1", letters: ""), .init(value: "2", letters: "ABC"), .init(value: "3", letters: "DEF")],
        [.init(value: "4", letters: "GHI"), .init(value: "5", letters: "JKL"), .init(value: "6", letters: "MNO")],
        [.init(value: "7", letters: "PQRS"), .init(value: "8", letters: "TUV"), .init(value: "9", letters: "WXYZ")],
        [.init(value: "*", letters: ""), .init(value: "0", letters: "+"), .init(value: "#", letters: "")]
    ]

    private var selectedStyle: DisplayStyle {
        DisplayStyle(rawValue: selectedStyleRaw) ?? .styleA
    }

    private var profile: USSDProfile {
        .init(phoneNumber: phoneNumber, mainBalance: mainBalance, expiryDate: expiryDate)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                topCarrierBadge

                Spacer(minLength: 20)

                Text(dialed.isEmpty ? " " : dialed)
                    .font(.system(size: dialed.count > 12 ? 35 : 43, weight: .regular))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.68)
                    .frame(height: 54)
                    .padding(.horizontal, 26)
                    .contentTransition(.numericText())

                Spacer(minLength: 12)

                keypad

                Spacer(minLength: 24)

                callRow

                Spacer(minLength: 18)

                bottomTabBar
            }
            .padding(.bottom, 8)
        }
        .sheet(isPresented: $showStylePicker) {
            DisplayStyleView(selectedStyleRaw: $selectedStyleRaw)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showProfileSettings) {
            SettingsView(
                phoneNumber: $phoneNumber,
                mainBalance: $mainBalance,
                expiryDate: $expiryDate
            )
        }
        .fullScreenCover(isPresented: $showUSSD) {
            USSDResultView(profile: profile, style: selectedStyle) {
                showUSSD = false
            }
        }
        .alert("Không hỗ trợ", isPresented: $showUnsupported) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Bản này chỉ hỗ trợ mã *101#.")
        }
        .preferredColorScheme(.dark)
    }

    private var topCarrierBadge: some View {
        Color.clear
            .frame(height: 24)
    }

    private var keypad: some View {
        VStack(spacing: 14) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 31) {
                    ForEach(row) { key in
                        DialButton(key: key) {
                            append(key.value)
                        }
                    }
                }
            }
        }
    }

    private var callRow: some View {
        ZStack {
            Button(action: call) {
                Circle()
                    .fill(Color(red: 0.04, green: 0.53, blue: 0.20))
                    .frame(width: 84, height: 84)
                    .overlay {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 33, weight: .semibold))
                            .foregroundStyle(.white)
                    }
            }
            .buttonStyle(PressScaleStyle())

            HStack {
                Spacer()

                if !dialed.isEmpty {
                    Button(action: deleteLast) {
                        Image(systemName: "delete.left.fill")
                            .font(.system(size: 24, weight: .regular))
                            .foregroundStyle(.white)
                            .frame(width: 46, height: 36)
                    }
                    .buttonStyle(PressScaleStyle())
                    .transition(.opacity.combined(with: .scale))
                } else {
                    Color.clear.frame(width: 46, height: 36)
                }
            }
            .padding(.trailing, 84)
        }
        .frame(height: 84)
    }

    private var bottomTabBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 0) {
                bottomTab(icon: "clock.fill", title: "Cuộc gọi", selected: false) {
                    showStylePicker = true
                }

                bottomTab(icon: "person.crop.circle.fill", title: "Danh bạ", selected: false) {
                    showProfileSettings = true
                }

                bottomTab(icon: "circle.grid.3x3.fill", title: "Bàn phím", selected: true) { }
            }
            .padding(4)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.10))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.white.opacity(0.08), lineWidth: 0.7))

            Button { } label: {
                Circle()
                    .fill(Color.white.opacity(0.10))
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 25, weight: .regular))
                            .foregroundStyle(.white)
                    }
                    .overlay(Circle().stroke(Color.white.opacity(0.08), lineWidth: 0.7))
            }
            .buttonStyle(PressScaleStyle())
        }
        .padding(.horizontal, 20)
    }

    private func bottomTab(
        icon: String,
        title: String,
        selected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 21, weight: .semibold))
                    .foregroundStyle(selected ? .blue : .white)

                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(selected ? .blue : .white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(selected ? Color.white.opacity(0.14) : Color.clear)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func append(_ value: String) {
        guard dialed.count < 24 else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.snappy(duration: 0.14)) {
            dialed.append(value)
        }
    }

    private func deleteLast() {
        guard !dialed.isEmpty else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        withAnimation(.snappy(duration: 0.14)) {
            dialed.removeLast()
        }
    }

    private func call() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if dialed.trimmingCharacters(in: .whitespacesAndNewlines) == "*101#" {
            showUSSD = true
        } else {
            showUnsupported = true
        }
    }
}

struct DialButton: View {
    let key: DialKey
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color(red: 0.075, green: 0.075, blue: 0.08))
                .overlay {
                    Circle().stroke(Color.white.opacity(0.10), lineWidth: 1)
                }
                .frame(width: 84, height: 84)
                .overlay {
                    VStack(spacing: -2) {
                        Text(key.value)
                            .font(.system(size: key.value == "*" ? 45 : 40, weight: .regular))
                            .foregroundStyle(.white)
                            .frame(height: 49)

                        if !key.letters.isEmpty {
                            Text(key.letters)
                                .font(.system(size: 11, weight: .bold))
                                .tracking(2.0)
                                .foregroundStyle(.white)
                        }
                    }
                }
        }
        .buttonStyle(PressScaleStyle())
    }
}

struct PressScaleStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.91 : 1)
            .opacity(configuration.isPressed ? 0.78 : 1)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}
