//
//  HomeView.swift
//  WeatherApp
//
//  Created by anas amer on 26/08/2024.
//

import SwiftUI
import SDWebImage
struct HomeView: View {
    @StateObject private var vm = HomeViewModel()
   
    var body: some View {
        ZStack {
            NavigationView {
                VStack{
                    if vm.hideComponent{
                        VStack(spacing: 10) {
                            Image(systemName: "wifi.slash")
                                .font(.title3)
                                .foregroundStyle( .red)
                            
                            Text( "Disconnected")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                        }
                        .frame(height: 50)
                    }
                    ScrollView {
                        LazyVStack {
                            ForEach(vm.weatherTime.indices, id: \.self) { index in
                                WeatherRowItem(
                                    time: vm.weatherTime[index],
                                    temperature2M: "\(vm.weatherTemp[index])",
                                    icon: vm.getCodeIcon(vm.weatherCode[index]),
                                    unit: vm.toFahrenheit
                                )
                               
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if !vm.hideComponent{
                        HStack{
                            TextField(text: $vm.location) {
                                Text("Enter location")
                            }
                            .textFieldStyle(.roundedBorder)
                            
                            Button(action: {
                                if(!vm.location.isEmpty){
                                    vm.searchLocation()
                                }
                            }, label: {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .font(.title)
                            })
                            
                        }
                        .padding(.bottom)
                   
                    }
                    Picker(selection: $vm.toFahrenheit) {
                        Text("°C").tag(0)
                        Text("°F").tag(1)
                    } label: {
                        Text("Unit")
                    }.pickerStyle(.segmented)
                        .frame(width: 120)
                        .padding(.bottom)
                 
                }
                .padding(.horizontal)
                .navigationTitle("Mobile Weather")
                .alert(isPresented: $vm.showErrorAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(vm.errorMessage ?? "Unknown error"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            if vm.isLoading{
                ZStack{
                    Color.white
                        .opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView("Loading...")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                        )
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
            }
        }
    }
}
#Preview {
    HomeView()
}
