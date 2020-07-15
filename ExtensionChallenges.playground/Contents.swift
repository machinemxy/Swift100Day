//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

extension UIView {
    func bounceOut(duration: Double) {
        Self.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

extension Int {
    func times(doThing: () -> Void) {
        for _ in 1...self {
            doThing()
        }
    }
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let location = self.firstIndex(of: item) {
            self.remove(at: location)
        }
    }
}

class MyViewController : UIViewController {
    var label: UILabel!
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        label.backgroundColor = .yellow
        
        view.addSubview(label)
        self.view = view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        label.bounceOut(duration: 3)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

5.times {
    print("fuck")
}

var fruits = ["Apple", "Orange", "Pear", "Banana"]
fruits.remove(item: "Orange")
print(fruits)
