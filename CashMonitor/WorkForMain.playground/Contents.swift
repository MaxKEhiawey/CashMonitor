import Foundation


let jsonData = """
{
    "employees": [
        {
            "firstName": "Peter",
            "lastName": "Heinisch",
            "dateOfBirth": "1981-07-28",
            "dateOfEmployment": "2013-07-28",
            "id": 1
        },
        {
            "firstName": "Katrin",
            "lastName": "Kleesattel",
            "dateOfBirth": "2001-06-18",
            "dateOfEmployment": "2001-06-18",
            "id": 2
        },
        {
            "firstName": "Tine",
            "lastName": "Dietloff",
            "dateOfBirth": "1993-08-01",
            "dateOfEmployment": "2020-08-03",
            "id": 5
        },
        {
            "firstName": "Patrick",
            "lastName": "Schneider",
            "dateOfBirth": "1991-10-12",
            "dateOfEmployment": "2016-01-01",
            "id": 7
        }
    ]
}
""".data(using: .utf8)!

struct Employee: Codable, Equatable, Hashable {
    let firstName, lastName, dateOfBirth, dateOfEmployment: String
}
struct Event: Codable, Hashable {
    var id = UUID()
    let employee, dateOfEvent, month: String
    let isDateOfEmployment: Bool
}

struct Root: Codable {
    let employees: [Employee]
}
struct MonthlyAnniversary: Hashable {
    let name: String
    var days: [Day] = []
}

struct Day: Hashable, Equatable {
    let date: String
    var events: [Event] = []
}

var newArr = [Event]()

var monthlyAnniversary = [MonthlyAnniversary]()
    // Parse JSON data
do {
    let decoder = JSONDecoder()
    let root = try decoder.decode(Root.self, from: jsonData)

        // Create a dictionary to group employees by month and day


    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let calendar = Calendar.current

        //    for employee in root.employees {
        //        guard let employmentDate = dateFormatter.date(from: employee.dateOfEmployment) else {
        //            continue
        //        }
        //
        //        let monthKey = "\(calendar.component(.year, from: employmentDate))-\(calendar.component(.month, from: employmentDate))"
        //        let dayKey = "\(calendar.component(.day, from: employmentDate))"
        //
        //        if anniversaryDict[monthKey] == nil {
        //            anniversaryDict[monthKey] = [dayKey: [employee]]
        //        } else {
        //            if anniversaryDict[monthKey]![dayKey] == nil {
        //                anniversaryDict[monthKey]![dayKey] = [employee]
        //            } else {
        //                anniversaryDict[monthKey]![dayKey]?.append(employee)
        //            }
        //        }
        //    }

    func getMonth(dateString: String ) -> String {
        var value = ""
            //let dateString = "2016-03-23"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let date = dateFormatter.date(from: dateString) {
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MM"

            let month = monthFormatter.string(from: date)
            value = month
        } else {
            print("Invalid date format")
        }
        return value
    }
        // Convert dictionary to the desired structure
    var monthlyAnniversaries = [MonthlyAnniversary]()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    for employee in root.employees {
        let formattedMonth1 = getMonth(dateString: employee.dateOfBirth)
        var firstEvent = Event(employee: "\(employee.firstName) \(employee.lastName)", dateOfEvent: employee.dateOfBirth, month: getMonth(dateString: employee.dateOfBirth), isDateOfEmployment: false)
        var secondEvent = Event(employee: "\(employee.firstName) \(employee.lastName)", dateOfEvent: employee.dateOfEmployment, month: getMonth(dateString: employee.dateOfEmployment), isDateOfEmployment: true)
        newArr.append(contentsOf: [firstEvent, secondEvent])

    }

        // print(newArr)
    func getCurrentMonthItem(arr: [MonthlyAnniversary]) -> MonthlyAnniversary {
        var item = MonthlyAnniversary(name: "")
        for month in arr {
            if month.name == "08" {
                item = month
            }
        }
        return item
    }
        // create a set of months
        //
    var monthSet = Set<MonthlyAnniversary>()

    let sorted  = newArr.sorted {$0.month < $1.month}
    for item in sorted {
        var object = MonthlyAnniversary(name: item.month, days: [])
        monthSet.insert(object)
    }
    var months = Array(monthSet)
    for item in sorted {
        var newEvent = Event(employee: item.employee , dateOfEvent: item.dateOfEvent, month: item.month, isDateOfEmployment: item.isDateOfEmployment)
        for (monthIndex, month) in months.enumerated() {
            if newEvent.month == month.name {
                if let index = month.days.firstIndex(where: { $0.date == newEvent.dateOfEvent }) {
                    months[monthIndex].days[index].events.append(newEvent)
                } else {
                    var newDay = Day(date: item.dateOfEvent, events: [newEvent])
                    months[monthIndex].days.append(newDay)
                }

            }
        }

    }
    let sortedM  = months.sorted { $0.name < $1.name }
    let rearrangedArray = rearrangeArray(sortedM, with:getCurrentMonthItem(arr: sortedM))

    print("month Sorted", rearrangedArray)

} catch {
    print("Error decoding JSON:", error)
}


func monthNumberToName(_ monthNumber: Int) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM"
    return dateFormatter.monthSymbols[monthNumber - 1]
}

let monthNumber = 3
if let monthName = monthNumberToName(monthNumber) {
    print("Month \(monthNumber) is \(monthName)")
} else {
    print("Invalid month number")
}

func monthNameToNumber(_ monthName: String) -> Int? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM"
    if let monthIndex = dateFormatter.monthSymbols.firstIndex(of: monthName) {
        return monthIndex + 1
    }
    return nil
}

let monthName = "June"
if let monthNumber = monthNameToNumber(monthName) {
    print("\(monthName) is month \(monthNumber)")
} else {
    print("Invalid month name")
}

func rearrangeArray<T: Equatable>(_ array: [T], with selectedItem: T) -> [T] {
    guard let selectedIndex = array.firstIndex(of: selectedItem) else {
        return array
    }

    let leadingItems = array.suffix(from: selectedIndex)
    let trailingItems = array.prefix(upTo: selectedIndex)

    return Array(leadingItems + trailingItems)
}

let orderedArray = ["A", "B", "C", "D", "E", "F", "G"]
let selectedItem = "E"
let rearrangedArray = rearrangeArray(orderedArray, with: selectedItem)

print(rearrangedArray)
