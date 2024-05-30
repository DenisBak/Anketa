//
//  ContentView.swift
//  Anketa
//
//  Created by Edik on 30/05/24.
//

import SwiftUI
import MessageUI

struct AnketaView: View {
    private let baseMail = "edikazizyan@yandex.ru"
    @State private var fullName = ""
    @State private var dateOfBirth = ""
    @State private var phoneNumber = ""
    @State private var mail = ""
    @State private var numberOfChildrens = ""
    @State private var responsibilityForChildren = ""
    
    @State private var isWaterSlidesEnabled = false
    @State private var isIndoorPoolEnabled = false
    @State private var isChildrensAreaEnabled = false
    @State private var isFoodCourtEnabled = false
    @State private var isSpaEnabled = false
    @State private var isSerfingEnabled = false
    
    @State private var isDataProcessingEnabled = false
    @State private var isBehaviourRoolsEnabled = false
    
    @State private var isShowingMailCompose = false
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
                .onTapGesture {
                    UIApplication.shared.endEditing(true)
                }
            
            ScrollView {
                header
                    .padding(.top)
                    .padding(.bottom, 28)
                
                VStack(spacing: 18) {
                    TextFieldView(
                        title: "Полное Имя",
                        text: $fullName,
                        state: .string,
                        placeholder: "Введите полное имя"
                    )
                    
                    TextFieldView(
                        title: "Дата Рождения",
                        text: $dateOfBirth,
                        state: .date,
                        placeholder: "Введите дату рождения"
                    )
                    
                    TextFieldView(
                        title: "Номер Телефона",
                        text: $phoneNumber,
                        state: .phoneNumber,
                        placeholder: "Введите томер телефона"
                    )
                    
                    TextFieldView(
                        title: "Электронная почта",
                        text: $mail,
                        state: .email,
                        placeholder: "Введите электронную почту"
                    )
                    
                    TextFieldView(
                        title: "Кто берет ответственностью за ребенка (детей)",
                        text: $responsibilityForChildren,
                        state: .string,
                        placeholder: "Введите полное имя"
                    )
                    
                    VStack(spacing: 12) {
                        Text("Зоны отдыха и развлечения")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 4)
                        
                        toggleEmojiView(
                            value: $isWaterSlidesEnabled,
                            text: "Водные горки",
                            image: "🛝".image()
                        )
                        .onTapGesture {
                            isWaterSlidesEnabled.toggle()
                        }
                        
                        toggleEmojiView(
                            value: $isIndoorPoolEnabled,
                            text: "Крытый/Закрытый бассейн",
                            image: "🏊‍♂️".image()
                        )
                        .onTapGesture {
                            isIndoorPoolEnabled.toggle()
                        }
                        
                        toggleEmojiView(
                            value: $isChildrensAreaEnabled,
                            text: "Детская зона",
                            image: "👶".image()
                        )
                        .onTapGesture {
                            isChildrensAreaEnabled.toggle()
                        }
                        
                        toggleEmojiView(
                            value: $isFoodCourtEnabled,
                            text: "Фуд корт",
                            image: "🍔".image()
                        )
                        .onTapGesture {
                            isFoodCourtEnabled.toggle()
                        }
                        
                        toggleEmojiView(
                            value: $isSpaEnabled,
                            text: "Спа",
                            image: "🧖‍♂️".image()
                        )
                        .onTapGesture {
                            isSpaEnabled.toggle()
                        }
                        
                        toggleEmojiView(
                            value: $isSerfingEnabled,
                            text: "Сёрфинг",
                            image: "🏄‍♀️".image()
                        )
                        .onTapGesture {
                            isSerfingEnabled.toggle()
                        }
                    }
                    
                    TextFieldView(
                        title: "Количество Детей",
                        text: $numberOfChildrens,
                        state: .numbers,
                        placeholder: "Введите количество детей"
                    )
                    
                    toggleView(
                        value: $isBehaviourRoolsEnabled,
                        text: "Я ознакомлен (а) с правилами и нормами поведения, установленными Аквапарком «Морская звезда» И в случае чего понесу полную гражданско-правовую, административную, уголовную и материальную ответственность."
                    )
                    .onTapGesture {
                        isBehaviourRoolsEnabled.toggle()
                    }
                    
                    toggleView(
                        value: $isDataProcessingEnabled,
                        text: "Согласие на обработку персональных данных"
                    )
                    .onTapGesture {
                        isDataProcessingEnabled.toggle()
                    }
                    
                    Button(action: {
                        if canUserSendData(), MFMailComposeViewController.canSendMail() {
                            isShowingMailCompose = true
                        }
                    }, label: {
                        Text("Отправить Анкету")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(.blue)
                            .cornerRadius(16)
                    })
                    .padding(.bottom, 40)
                    .padding(.top, 20)
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .sheet(isPresented: $isShowingMailCompose) {
            MailComposeView(
                isPresented: $isShowingMailCompose,
                recipients: [baseMail],
                subject: fullName,
                body: configureMessageBody()
            )
        }
    }
}

extension AnketaView {
    @ViewBuilder private var header: some View {
        Text("Анкета Аквапарка")
            .font(.title2)
            .foregroundStyle(.white)
            .padding(.top, 52)
    }
    
    @ViewBuilder private func toggleEmojiView(value: Binding<Bool>, text: String, image: UIImage?) -> some View {
        if let image {
            HStack(spacing: 12) {
                if value.wrappedValue {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.blue, lineWidth: 1)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.blue, lineWidth: 1)
                        .frame(width: 18, height: 18)
                }
                
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        }
    }
    
    @ViewBuilder private func toggleView(value: Binding<Bool>, text: String) -> some View {
        if let image = "✅".image() {
            HStack(spacing: 12) {
                if value.wrappedValue {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.blue, lineWidth: 1)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.blue, lineWidth: 1)
                        .frame(width: 18, height: 18)
                }
                
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        }
    }
    
    private func configureMessageBody() -> String {
        return """
            Полное имя: \(fullName)
            Дата Рождения: \(dateOfBirth)
            Номер Телефона: \(phoneNumber)
            Электронная Почта: \(mail)
            Кто несёт ответственность за детей: \(responsibilityForChildren)
            Количество Детей: \(numberOfChildrens)
        
            Зоны Отдыха:
            Водные Горки: \(boolToFormattedString(isWaterSlidesEnabled))
            Крытый бассейн: \(boolToFormattedString(isIndoorPoolEnabled))
            Детская Зона: \(boolToFormattedString(isChildrensAreaEnabled))
            Фуд корт: \(boolToFormattedString(isFoodCourtEnabled))
            Спа: \(boolToFormattedString(isSpaEnabled))
            Сёрфинг: \(boolToFormattedString(isSerfingEnabled))
        """
    }
    
    private func boolToFormattedString(_ value: Bool) -> String {
        return value ? "Активно" : "Неактивно"
    }
    
    private func canUserSendData() -> Bool {
        guard
            !fullName.isEmpty,
            !dateOfBirth.isEmpty,
            !phoneNumber.isEmpty,
            !mail.isEmpty,
            !numberOfChildrens.isEmpty,
            !responsibilityForChildren.isEmpty,
            isDataProcessingEnabled,
            isBehaviourRoolsEnabled
        else {
            return false
        }
            
        return true
    }
}

#Preview {
    AnketaView()
        .background(Color.black)
}
