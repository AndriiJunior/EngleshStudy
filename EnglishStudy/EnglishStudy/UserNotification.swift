//
//  UserNotification.swift
//  EnglishStudy
//
//  Created by AndyBrila on 29.06.2022.
//

import SwiftUI
import UserNotifications

class UserNotificationManager {
    static let instance = UserNotificationManager()
    func requestAvtorization() {
        let options :UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (succes, error) in
            if let error = error{
                print("ERROR \(error)")
            }else{
                print("Succes")
            }
        }
    }
    
    func EveryDayNotification(){
   
        let content = UNMutableNotificationContent()
        content.title = "Did you forget about English?????"
        content.subtitle = "LEARN NEW WORDS QUICKLY!!!!"
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
    }
}


   




struct UserNotification: View {
    
    var body: some View {
        VStack{
            Button(action: {
                UserNotificationManager.instance.requestAvtorization()
                
                          }, label: {
                Text("")
            })
        }
    }
}

struct UserNotification_Previews: PreviewProvider {
    static var previews: some View {
        UserNotification()
    }
}
