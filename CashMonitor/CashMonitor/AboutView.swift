//
//  AboutView.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 15/08/2023.
//

import SwiftUI

struct AboutView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            ZStack {
                Color.primaryColor.edgesIgnoringSafeArea(.all)

                VStack {
                    ToolbarModelView(title: "About") { self.presentationMode.wrappedValue.dismiss() }

                    Spacer().frame(height: 80)
                    Image("logo")
                        .resizable()
                        .frame(width: 120.0, height: 120.0)
                        .cornerRadius(48)
                   // Image(systemName: "chart.line.uptrend.xyaxis").resizable().frame(width: 120.0, height: 120.0)
                    TextView(text: "\(APPNAME)", type: .h6Type)
                        .foregroundColor(Color.textPrimaryColor)
                        .padding(.top, 20)
                    TextView(text: "v\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] ?? "")", type: .body2)
                        .foregroundColor(Color.textSecondaryColor).padding(.top, 2)

                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack { Spacer() }
                            TextView(text: "ATTRIBUTIONS & LICENSE", type: .overline)
                                .foregroundColor(Color.textPrimaryColor)
                            TextView(text: "Licensed Under Apache License 2.0", type: .body2)
                                .foregroundColor(Color.textSecondaryColor).padding(.top, 2)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            HStack { Spacer() }
                            TextView(text: "VISIT", type: .overline).foregroundColor(Color.textPrimaryColor)
                            TextView(text: "\(APPLINK)", type: .body2)
                                .foregroundColor(Color.mainColor).padding(.top, 2)
                                .onTapGesture {
                                    if let url: URL = URL(string: APPLINK) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                        }
                    }.padding(20)

                    Spacer()
                }.edgesIgnoringSafeArea(.all)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
