//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

//
//        let shadow = UIView(frame: label.frame)
//        view.addSubview(shadow)
//        view.sendSubviewToBack(shadow)
//
//        shadow.layer.shadowPath = UIBezierPath(roundedRect: label.bounds, cornerRadius: 0).cgPath
//        shadow.layer.shadowColor = UIColor.lightGray.cgColor
//        shadow.layer.shadowOpacity = 0.3
//        shadow.layer.shadowOffset = .zero
//        shadow.layer.shadowRadius = 4
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let upperHalf = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3))
        let block1 = Block(frame: CGRect(x: 50, y: 100, width: 60, height: 100))
        upperHalf.addSubview(block1)
        upperHalf.backgroundColor = .black

        let lowerHalf = UIView(frame: CGRect(x: 0, y: upperHalf.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3))
        let block2 = Block(frame: CGRect(x: 50, y: 100, width: 60, height: 100))
        lowerHalf.addSubview(block2)
        lowerHalf.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1)
        
        // 黑色
        block1.backgroundColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1)
        block1.label.textColor = .white
        block1.label.backgroundColor = .clear
        block1.imageView.image = UIImage(systemName: "multiply.circle.fill")
        block1.imageView.backgroundColor = .clear
        block1.layer.cornerRadius = 4
        block1.layer.masksToBounds = true

        block2.backgroundColor = .white
        block2.label.backgroundColor = .clear
        block2.label.textColor = .black
        block2.imageView.image = UIImage(systemName: "multiply.circle.fill")
        block2.imageView.backgroundColor = .clear
        block2.layer.cornerRadius = 4
        block2.layer.masksToBounds = true

        view.addSubview(upperHalf)
        view.addSubview(lowerHalf)
        
        /* 黑白theme的适配 */
        
    }
}

class Block: UIView {
    
    /// 图片
    let imageView = UIImageView(frame: .zero)
    
    let label = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let width: CGFloat = 50
        imageView.frame = CGRect(x: (frame.width - width)/2, y: 10, width: width, height: width)
        addSubview(imageView)
        label.frame = CGRect(x: 8, y: imageView.frame.maxY + 8, width: frame.width - 16, height: frame.height - 8 - width - 10)
        label.text = "Hello"
        label.textAlignment = .center
        addSubview(label)
        
        label.backgroundColor = .blue
        imageView.backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
