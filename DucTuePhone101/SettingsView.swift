import SwiftUI
import UIKit

struct DisplayStyleView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedStyleRaw: String

    private var selectedStyle: DisplayStyle {
        DisplayStyle(rawValue: selectedStyleRaw) ?? .styleA
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 14) {
                    Text("Chọn cách hiển thị")
                        .font(.system(size: 27, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Chọn nhà mạng dùng cho kết quả *101#.")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 8)

                    styleButton(.styleA)
                    styleButton(.styleB)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Xong") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func styleButton(_ style: DisplayStyle) -> some View {
        Button {
            selectedStyleRaw = style.rawValue
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            HStack(spacing: 15) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .frame(width: 46, height: 46)
                    .overlay {
                        Text(style.badgeLetter)
                            .font(.system(size: 25, weight: .bold))
                            .foregroundStyle(.white)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(style.title)
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(.white)
                    Text(style.subtitle)
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                }

                Spacer()

                Image(systemName: selectedStyle == style ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundStyle(selectedStyle == style ? .blue : .gray)
            }
            .padding(16)
            .background(Color.white.opacity(0.07))
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
        .buttonStyle(.plain)
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var phoneNumber: String
    @Binding var mainBalance: String
    @Binding var expiryDate: String

    @FocusState private var focusedField: Field?

    enum Field {
        case phone
        case balance
        case expiry
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Thông tin *101#")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)

                        Text("Nhập dữ liệu dùng cho màn kết quả *101#.")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)

                        fieldCard(
                            number: "1",
                            title: "Số điện thoại",
                            placeholder: "0900000000",
                            text: $phoneNumber,
                            keyboard: .phonePad,
                            field: .phone
                        )

                        fieldCard(
                            number: "2",
                            title: "Số tiền",
                            placeholder: "10.000",
                            text: $mainBalance,
                            keyboard: .numbersAndPunctuation,
                            field: .balance
                        )

                        fieldCard(
                            number: "3",
                            title: "Ngày hết hạn",
                            placeholder: "31/12/2026",
                            text: $expiryDate,
                            keyboard: .numbersAndPunctuation,
                            field: .expiry
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Xong") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func fieldCard(
        number: String,
        title: String,
        placeholder: String,
        text: Binding<String>,
        keyboard: UIKeyboardType,
        field: Field
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Text(number)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Color.blue)
                    .clipShape(Circle())

                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }

            TextField(placeholder, text: text)
                .focused($focusedField, equals: field)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .tint(.blue)
                .padding(.horizontal, 16)
                .frame(height: 54)
                .background(Color.white.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}
