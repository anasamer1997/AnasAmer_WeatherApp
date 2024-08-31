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
                    
                    ScrollView {
                        if vm.hideComponent{
                            NetworkView()
                        }
                        WeatherListView(vm: vm)
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
                                    vm.location = ""
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
                LoadingView()
            }
        }
    }
}
#Preview {
    HomeView()
}
