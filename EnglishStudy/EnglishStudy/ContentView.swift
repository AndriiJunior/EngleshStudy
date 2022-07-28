//
//  ContentView.swift
//  EnglishStudy
//
//  Created by AndyBrila on 22.06.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var Answer = ""
    @State private var BotCheckAnswer = false
    @State private var BotStopPlay = false
    @State private var AnswerTitel = ""
    @State private var AlertMasseg = ""
    @State private var ButDictionary = false
    @State private var CountAnswer = 0
    @State private var RandomWord = ["", ""]
  
    @FetchRequest(sortDescriptors:[]) private var UsersCD: FetchedResults<UsersWordCD>
    @Environment(\.managedObjectContext) var viewContext
   
    func RandomDictioneryWord() -> Array<String> {
        let RandomElement = UsersCD.randomElement()
        let UkrWord = RandomElement?.ukrWord
        let EngWord = RandomElement?.engWord
        self.RandomWord [0] = EngWord ?? ""
        self.RandomWord [1] = UkrWord ?? ""
        return RandomWord
        
    }
    
    
    func CheckAnswer(answer: String) {
        if answer == RandomWord[0] {
            AnswerTitel = "Correct!!!"
            AlertMasseg = "Good job ;)"
            CountAnswer += 1
            self.RandomWord = ClearArry(RandomWord: RandomWord)
            self.RandomWord = RandomDictioneryWord()
            
        }
        else{
            AnswerTitel = "Wrong answer!!!"
            AlertMasseg = "OO no, Correct answer '\(RandomWord[0])' try again)))"
            CountAnswer -= 1
        }
        Answer = ""
       
        
    }
    func ClearArry(RandomWord: Array<String>) -> Array<String> {
        self.RandomWord = [""]
        return RandomWord
    }
   
    
    
    
    var body: some View {
        
    
ZStack{

LinearGradient(gradient: Gradient(colors: [Color.blue, Color.yellow]), startPoint: .top, endPoint: .bottom)
    .edgesIgnoringSafeArea(.all)



VStack(alignment: .trailing, spacing: 50){
    
    
    HStack(spacing: 100){
        
        Button(action: {
            self.RandomWord = RandomDictioneryWord()
        }, label: {
            Image(systemName: "play.rectangle.fill")
                .font(.largeTitle)
                .foregroundColor(.black)
        }).padding(.horizontal,20)
           

        Button(action: {
            UserNotificationManager.instance.requestAvtorization()
            UserNotificationManager.instance.EveryDayNotification()

           
        }, label: {
            Image(systemName: "bell.badge.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.black)
        })
        
        Button(action: {
            self.ButDictionary.toggle()
        }, label: {
        Image(systemName: "character.book.closed.fill")
            .font(.largeTitle)
            .foregroundColor(.black)
        }).sheet(isPresented: $ButDictionary, content: {
            Dictionary()
        }).padding(.horizontal,20)
      
    }
   
    
    
    Text("How to corectly write  '\(RandomWord[1])'???").font(.largeTitle).foregroundColor(.white)
        .position(x: 200, y: 0)
        .frame(height: 100, alignment:.center)
    HStack(){
    Text("Number of Answer: \(CountAnswer)")
            
        .font(.largeTitle)
        .foregroundColor(Color.init(#colorLiteral(red: 0.3244451144, green: 0.9902475476, blue: 0.6818576403, alpha: 1)))
        .position(x: 200, y: 20)
        
    }.frame(width: 400, height: 40, alignment: .trailing)
    HStack{
    TextField("Enter yous answer", text:$Answer)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }.position(x: 195, y:20)
        .frame(width: 400, height: 40)
    
    Spacer()
    
    HStack(alignment: .center){

        Button(action: {
            self.CheckAnswer(answer: Answer)
            self.BotCheckAnswer = true
            
        }, label: {
            Text("Check answer")
                .bold()
                .font(.title)
                .foregroundColor(.pink)
        }).frame(width: 140, height: 150)
        .background(Color.yellow)
        .clipShape(Circle())
        
        
    }.position(x: 205, y: 90)
}.onAppear{UIApplication.shared.applicationIconBadgeNumber = 0}

.alert(isPresented: $BotCheckAnswer){
    
    Alert(title: Text(AnswerTitel), message: Text(AlertMasseg), dismissButton: .default(Text("Continue")))
    
            }

        }


    }

}
        

        
struct Dictionary: View {
    @State private var EngAddWord = ""
    @State private var UkrAddWord = ""
    @State private var ButtAdd = false
    @FetchRequest(sortDescriptors:[]) private var UsersCD: FetchedResults<UsersWordCD>
    @Environment(\.managedObjectContext) var viewContext
@Environment(\.presentationMode) var presentationMode
    @State private var AlertTitel = ""
    @State private var AlertMasseg = ""
    @State private var AlertCall = false
    
 func deleteWord(offsets: IndexSet){
    for index in offsets{
    let deleteWord = UsersCD[index]
    viewContext.delete(deleteWord)
    }
    do {
    try viewContext.save()
    } catch {
    let error = error as NSError
    fatalError("unresolved error:\(error)")
    }
}
    func CheckUserTextField(EngWriteWord:String, UkrWriteWord:String){
        if !(EngAddWord.isEmpty || UkrWriteWord.isEmpty) {
            let newWordCD = UsersWordCD(context: viewContext)
             newWordCD.engWord = EngAddWord
             newWordCD.ukrWord = UkrAddWord
            
            do{
                try self.viewContext.save()
            }
            catch{
            let error = error as NSError
            fatalError("unresolved error:\(error)")
                
        }
             AlertTitel = "Congratulations!!!"
             AlertMasseg = "Your word is saved!"
            EngAddWord = ""
            UkrAddWord = ""
        }
        else{
            AlertTitel = "WARRNING!!!"
            AlertMasseg = "You didn't write a word! Try again!"
        }
        
    }
    
    

var body: some View{
    
   
NavigationView{
    List{
    Section(header: Text("Add New Word")){
        
        VStack(spacing: 20){
            Link(destination: URL(string: "http://easy-english.com.ua/english-vocabulary-4-grade/")!) {
                Label {
                    Text("Here you can find new words")
                } icon: {
                    Image(systemName: "magnifyingglass")
                }

            }
        TextField("Enter English Word", text: $EngAddWord)
            .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Enter Ukraine Word", text: $UkrAddWord)
                .textFieldStyle(RoundedBorderTextFieldStyle())}
        HStack(alignment:.center){
            Button(action: {
                self.ButtAdd = false
                self.AlertCall = true
                self.CheckUserTextField(EngWriteWord: EngAddWord, UkrWriteWord: UkrAddWord)

            }, label: {
                Image(systemName: "plus.square.fill")
                    .font(.largeTitle)
                    .foregroundColor(.black)
            })
        }.frame(width: 40, height: 40)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        .position(x: 180, y: 20)

    }
    Section(header: Text("User Words")){

        
        ForEach(UsersCD, id:\.self){i in
            
            NavigationLink(
                destination: VStack{
                    Text("\(i.engWord ?? "" ) - Це").font(.largeTitle)
                    Text(i.ukrWord ?? "").font(.largeTitle)
                },
                label: {
            HStack{
                Text("\(i.engWord ?? "" ) -")
                Text(i.ukrWord ?? "" )
            }
                })

        }.onDelete(perform: deleteWord)
        
    }

    }.navigationBarTitle("",displayMode: .inline)
    .navigationBarItems(leading:
                        HStack(spacing: 50){

    Button(action: {
    self.presentationMode.wrappedValue.dismiss()
    }, label: {
        Image(systemName: "arrowshape.turn.up.left.fill")
            .font(.largeTitle)
        .foregroundColor(.black)})
    Text("DICTIONARY")
    .font(.largeTitle) })
        }.listStyle(GroupedListStyle())
    .alert(isPresented: $AlertCall, content: {
Alert(title: Text(AlertTitel), message: Text(AlertMasseg), dismissButton: .default(Text("Continue")))})
         
    }

}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
