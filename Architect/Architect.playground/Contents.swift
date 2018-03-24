//: Playground - noun: a place where people can play

import UIKit
import Foundation
import Cartography
import PlaygroundSupport

var str = "Hello, playground"


protocol BluePrint {

    var blueprint : Architect {get}
}

typealias LayoutCommands = ([UIView]) -> ()

typealias ArchitectQuery = () -> ([Architect])
indirect enum Architect {

    case viewController(ArchitectQuery, LayoutCommands?)
    case view(ArchitectQuery, LayoutCommands?)
    case stackView(ArchitectQuery, LayoutCommands?)
    case scrollView(ArchitectQuery, LayoutCommands?)
    case collectionView(ArchitectQuery, LayoutCommands?)
    case tableView(ArchitectQuery, LayoutCommands?)
    case activityIndicator(ArchitectQuery,LayoutCommands?)
    case control(ArchitectQuery,LayoutCommands?)
    case button(ArchitectQuery,LayoutCommands?)
    case segmentedControl(ArchitectQuery,LayoutCommands?)
    case slider(ArchitectQuery,LayoutCommands?)
    case stepper(ArchitectQuery,LayoutCommands?)
    case uiswitch(ArchitectQuery,LayoutCommands?)
    case pageControl(ArchitectQuery,LayoutCommands?)
    case datePicker(ArchitectQuery,LayoutCommands?)
    case visualEffectView(ArchitectQuery,LayoutCommands?)
    case imageView(ArchitectQuery,LayoutCommands?)
    case pickerView(ArchitectQuery,LayoutCommands?)
    case progressView(ArchitectQuery,LayoutCommands?)
    case webView(ArchitectQuery,LayoutCommands?)
    case custom(UIView)
    case blueprint(Architect)
    case label(ArchitectQuery,LayoutCommands?)
    case textView(ArchitectQuery,LayoutCommands?)
    case textfield(ArchitectQuery,LayoutCommands?)

    static func build(viewController: UIViewController, from architecture: Architect) {
        constructor(superView: viewController.view, architecture: architecture)
    }

    private static func constructor(superView: UIView, architecture: Architect) {
        switch architecture {
        case .viewController(let proxyViews, let plans):
            let views = proxyViews().reduce([superView], {result, architect in
                if case .blueprint(let arch) = architect {
                    let subView = viewForArchitect(arch)
                    constructor(superView: subView, architecture: arch)
                    result[0].addSubview(subView)
                    return result + [subView]
                }else if case .custom(let view) = architect {
                    result[0].addSubview(view)
                    return result + [view]
                } else {
                    let subView = viewForArchitect(architect)
                    constructor(superView: subView, architecture: architect)
                    result[0].addSubview(subView)
                    return result + [subView]
                }
            })
            plans?(views)
        case .view(let proxyViews, let plans):
            let views = proxyViews().reduce([superView], { result, architect in
                if case .blueprint(let arch) = architect {
                    let subView = viewForArchitect(arch)
                    constructor(superView: subView, architecture: arch)
                    result[0].addSubview(subView)
                    return result + [subView]
                }else if case .custom(let view) = architect {
                    result[0].addSubview(view)
                    return result + [view]
                } else {
                    let subView = viewForArchitect(architect)
                    constructor(superView: subView, architecture: architect)
                    result[0].addSubview(subView)
                    return result + [subView]
                }
            })
            plans?(views)
        case .stackView(let query, let plans):
            let views = query().reduce([superView], { result, architect in
                let stack = result[0] as? UIStackView
                if case .blueprint(let arch) = architect {
                    let subView = viewForArchitect(arch)
                    constructor(superView: subView, architecture: arch)
                    stack?.addArrangedSubview(subView)
                    return result + [subView]
                }else if case .custom(let view) = architect {
                    stack?.addArrangedSubview(view)
                    return result + [view]
                } else {
                    let subView = viewForArchitect(architect)
                    constructor(superView: subView, architecture: architect)
                    stack?.addArrangedSubview(subView)
                    return result + [subView]
                }
            })
            plans?(views)
        case .blueprint(let arch):
            let subView = viewForArchitect(arch)
            if case .custom = arch {
               superView.addSubview(subView)
            }else {
                constructor(superView: subView, architecture:arch)
                superView.addSubview(subView)
            }
        case .custom: return //The superview is me and the architecture is custom; nothing to do
        default:break
        }
    }

    private static func viewForArchitect(_ architect: Architect) -> UIView {
        switch architect {
        case .view, .viewController: return UIView()
        case .stackView: return UIStackView()
        case .blueprint(let arch): return viewForArchitect(arch)
        case .custom(let view): return view
        default:return UIView()
        }
    }
}

typealias BluePrintConvertible = AnyObject & BluePrint

class DesignedController: UIViewController {


}


class PCircularView: UIView {


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        maskToCircle()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func maskToCircle() {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true

        let maskLayer = CAShapeLayer()
        let mask = UIBezierPath(ovalIn: self.bounds)
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.path = mask.cgPath
        self.layer.mask = maskLayer
    }


}

extension DesignedController: BluePrint {


    var other : Architect {
        return .stackView(
            {[
                .custom(PCircularView(frame: CGRect.init(origin: .zero, size: CGSize(width:40, height:40)))),
                .view({[]})
                {views in
                    views[0].backgroundColor = .white
                }]
        })
        { views in
            let stack = (views[0] as! UIStackView)
            stack.axis = .vertical
            stack.spacing = 10
            stack.distribution = .fillEqually
        }
    }

    var blueprint : Architect {
        return .viewController({[
            .view({[]})
            { views in
                views[0].backgroundColor = .blue

            },
            .view({[]})
            {views in
                views[0].backgroundColor = .red
            },
            .blueprint(self.other)
            ]})
        { views in
            views[0].backgroundColor = .white
            constrain(views[0], views[1], block: { parent, view in
                view.left == parent.left + 10
                view.right == parent.right - 10
                view.top == parent.top + 10
                view.bottom == parent.bottom - 10
            })

            constrain(views[0], views[2]) { parent, view in
                view.left == parent.left + 20
                view.right == parent.right - 20
                view.top == parent.top + 20
                view.bottom == parent.bottom - 20
            }

            constrain(views[0], views[3]) { parent, view in
                view.left == parent.left + 30
                view.right == parent.right - 30
                view.top == parent.top + 30
                view.bottom == parent.bottom - 30
            }
        }

    }

}


let viewController = DesignedController()

Architect.build(viewController: viewController, from: viewController.blueprint)


PlaygroundPage.current.liveView = viewController






