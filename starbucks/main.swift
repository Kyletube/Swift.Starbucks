import Foundation

class StarBucks: MenuList {
    
    var cart: [(item: String, price: Int)] = []
    var waitingNumber: Int = 0
    var waitingTime: Int = 0
    var myMoney: Int = 100000
    
    func viewDrink() {
        print("\n***음료 메뉴***")
        print("1. 커피")
        print("2. 프라푸치노")
        print("3. 피지오")
        print("0. 메인 메뉴로 돌아가기")
        print("------------------------------")
        
        while true {
            if let userChoice = readLine(), let choice = Int(userChoice) {
                switch choice {
                case 1:
                    viewMenu(title: "커피", items: menuItems["커피"]!)
                    return
                case 2:
                    viewMenu(title: "프라푸치노", items: menuItems["프라푸치노"]!)
                    return
                case 3:
                    viewMenu(title: "피지오", items: menuItems["피지오"]!)
                    return
                case 0:
                    showMainMenu()
                    return
                default:
                    print("번호를 다시 선택해 주세요.")
                }
            } else {
                print("잘못된 입력입니다. 다시 입력해 주세요.")
            }
        }
    }
    
    func viewFood() {
        print("\n***푸드 메뉴***")
        viewMenu(title: "푸드", items: menuItems["푸드"]!)
    }
    
    func viewGoods() {
        print("\n***상품 메뉴***")
        viewMenu(title: "상품", items: menuItems["상품"]!)
    }
    
    func showMainMenu() {
        print("\n***안녕하세요, 스타벅스입니다***\n")
        print("메뉴를 선택해 주세요.\n")
        print("------------------------------")
        print("1. 음료")
        print("2. 푸드")
        print("3. 상품")
        print("4. 장바구니, 결제")
        print("5. 나의 잔액 보기")
        print("0. 프로그램 종료")
        print("------------------------------")
        
        
        if let userChoice = readLine(), let choice = Int(userChoice) {
            switch choice {
            case 1:
                viewDrink()
            case 2:
                viewFood()
            case 3:
                viewGoods()
            case 4:
                viewCart()
            case 5:
                print("\n현재 나의 잔액은 \(myMoney)원 입니다.")
                showMainMenu()
            case 0:
                print("프로그램을 종료합니다.")
            default:
                print("번호를 다시 선택해 주세요.")
            }
        } else {
            print("잘못된 입력입니다. 다시 입력해 주세요.")
        }
    }
    
    func viewMenu(title: String, items: [MenuItem]) {
        print("------------------------------")
        for (index, item) in items.enumerated() {
            print("\(index + 1). \(item.name) - \(item.price)원")
        }
        print("0. 메인 메뉴로 돌아가기")
        print("------------------------------")
        
        while true {
            if let userChoice = readLine(), let choice = Int(userChoice) {
                if choice >= 1 && choice <= items.count {
                    let selectedItem = items[choice - 1]
                    cart.append((item: selectedItem.name, price: selectedItem.price))
                    print("----------장바구니에 추가 되었습니다.----------")
                    showMainMenu()
                    return
                } else if choice == 0 {
                    showMainMenu()
                    return
                } else {
                    print("번호를 다시 선택해 주세요.")
                }
            } else {
                print("잘못된 입력입니다. 다시 입력해 주세요.")
            }
        }
    }
    
    func viewCart() {
        print("------------------------------")
        print("\n장바구니 목록\n")
        var totalPrice = 0
        for (index, item) in cart.enumerated() {
            print("\(index + 1). \(item.item) - 가격: \(item.price)원")
            totalPrice += item.price
        }
        
        print("\n총 합계: \(totalPrice)원")
        print("1. 주문        2. 메뉴 추가하기")
        print("\n메뉴로 돌아 가시려면 0번을 눌러주세요.")
        print("장바구니를 비우시려면 100번을 눌러주세요.")
        print("------------------------------")
        
        while true {
            if let userChoice = readLine(), let choice = Int(userChoice) {
                switch choice {
                case 0:
                    showMainMenu()
                    return
                case 1:
                    if cart.isEmpty {
                        print("주문 가능하신 물품이 없습니다 메뉴를 담아주세요.")
                        sleep(1)
                        showMainMenu()
                        return
                    } else {
                        if canPayment() {
                            print("은행 점검 시간입니다. 잠시후에 이용해 주세요. 점검시간: 23:50 ~ 23:59")
                            sleep(3)
                            showMainMenu()
                            return
                        } else {
                            payment(totalPrice: totalPrice)
                            return
                        }
                    }
                case 2:
                    showMainMenu()
                    return
                case 100:
                    cart = []
                    print("장바구니가 초기화 되었습니다.")
                    showMainMenu()
                    return
                default:
                    print("번호를 다시 선택해 주세요.")
                }
            } else {
                print("잘못된 입력입니다. 다시 입력해 주세요.")
            }
        }
    }
    
    func payment(totalPrice: Int) {
        if myMoney >= totalPrice {
            waitingNumber += 1
            waitingTime += 5
            myMoney -= totalPrice
            
            print("주문을 처리중입니다.")
            sleep(3)
            print("주문이 완료 되었습니다.")
            cart = []
            sleep(3)
            showMainMenu()
        } else {
            print("현재 잔액은\(myMoney)원 으로 \(totalPrice - myMoney)원이 부족해서 주문할 수 없습니다.")
            showMainMenu()
        }
    }
    
    func canPayment() -> Bool {
        let koreanTimeZone = TimeZone(identifier: "Asia/Seoul")!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = koreanTimeZone
        
        let currentDate = Date()
        
        guard let startTime = dateFormatter.date(from: "23:50"),
              let endTime = dateFormatter.date(from: "23:59") else {
            fatalError("날짜 형식 설정 중 오류가 발생했습니다.")
        }
        
        if let currentTime = dateFormatter.date(from: dateFormatter.string(from: currentDate)) {
            return (currentTime >= startTime && currentTime <= endTime)
        } else {
            return false
        }
    }

}

class AlertWaiting {
    func queue() {
        DispatchQueue.global().async {
            while true {
                sleep(5)
                print("현재 대기열 순번: \(starBucks.waitingNumber)")
                print("현재 주문이 나오기까지 걸리는 시간: \(starBucks.waitingTime)분")
            }
        }
    }
}

let starBucks = StarBucks()
let alertWaiting = AlertWaiting()

alertWaiting.queue()
starBucks.showMainMenu()



class MenuList {
    struct MenuItem {
        let name: String
        let price: Int
    }
    
    let menuItems: [String: [MenuItem]] = [
        "커피": [
            MenuItem(name: "아이스 아메리카노", price: 4500),
            MenuItem(name: "핫 아메리카노", price: 4500),
            MenuItem(name: "아이스 카페라떼", price: 5000),
            MenuItem(name: "핫 카페라떼", price: 5000),
            MenuItem(name: "콜드브루( Iced Only )", price: 4900)
        ],
        "프라푸치노": [
            MenuItem(name: "자바 칩 프라푸치노", price: 6300),
            MenuItem(name: "카라멜 프라푸치노", price: 5900),
            MenuItem(name: "그린티 프라푸치노", price: 6300)
        ],
        "피지오": [
            MenuItem(name: "유자 패션 피지오", price: 5900),
            MenuItem(name: "쿨 라임 피지오", price: 5900),
            MenuItem(name: "피치 딸기 피지오", price: 5700)
        ],
        "푸드": [
            MenuItem(name: "바비큐 치킨 치즈 치아바타", price: 5800),
            MenuItem(name: "바질 토마토 크림치즈 베이글", price: 5300),
            MenuItem(name: "베이컨 치즈 토스트", price: 4900)
        ],
        "상품": [
            MenuItem(name: "SS 스탠리 그린 캔처 텀블러 591ml", price: 39000),
            MenuItem(name: "SS 스탠리 크림 켄처 텀블러 591ml", price: 39000),
            MenuItem(name: "SS 엘마 블랙 텀블러 473ml", price: 33000)
        ]
    ]
}
