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
    case custom(AnyClass,ArchitectQuery,LayoutCommands?)
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
                let subView = viewForArchitect(architect) ?? result[0]
                constructor(superView: subView, architecture: architect)
                result[0].addSubview(subView)
                return result + [subView]
            })
            plans?(views)
        case .view(let proxyViews, let plans):
            let views = proxyViews().reduce([superView], { result, architect in
                let subView = viewForArchitect(architect) ?? result[0]
                constructor(superView: subView, architecture: architect)
                result[0].addSubview(subView)
                return result + [subView]
            })
            plans?(views)
        case .stackView(let query, let plans):
            let views = query().reduce([superView], { result, architect in
                let stack = result[0] as? UIStackView
                let subView = viewForArchitect(architect) ?? result[0]
                constructor(superView: subView, architecture: architect)
                stack?.addArrangedSubview(subView)
                return result + [subView]
            })
            plans?(views)
        case .blueprint(let arch):
            return constructor(superView: superView, architecture:arch)
        default:break
        }
    }

    private static func viewForArchitect(_ architect: Architect) -> UIView? {
        switch architect {
        case .view, .viewController:return UIView()
        case .stackView: return UIStackView()
        case .blueprint: return nil
        default:return UIView()
        }
    }
}

typealias BluePrintConvertible = AnyObject & BluePrint

let controller = Architect.viewController({[
    .view({[]})
    { views in
        views[0].backgroundColor = .blue

    },
    .view({[]})
    {views in
        views[0].backgroundColor = .red
    },
    .stackView(
        {[
        .view({[]})
        {views in
            views[0].backgroundColor = .white

        },
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


class fakeButton : UIButton {


}


class DesignedController: UIViewController {


}

extension DesignedController: BluePrint {


    var other : Architect {
        return .stackView(
            {[
                .view({[]})
                {views in
                    views[0].backgroundColor = .white

                },
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
            .blueprint(other)
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






