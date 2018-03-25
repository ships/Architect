//
//  Architect.swift
//  Architect
//
//  Created by Storybook Developer Axandre Oge on 3/22/18.
//  Copyright © 2018 oge. All rights reserved.
//

import Foundation
import UIKit

public typealias LayoutCommands = ([UIView]) -> ()

public typealias ArchitectQuery = () -> ([Architect])

indirect public enum Architect {
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

}

extension Architect {

    static public func build(viewController: UIViewController, from architecture: Architect) {
        constructor(superView: viewController.view, architecture: architecture)
    }

    static public func build(view: UIView, from architecture: Architect) {
        constructor(superView: view, architecture: architecture)
    }

    static func constructor(superView: UIView, architecture: Architect) {
        switch architecture {
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
        default:
            let query = architecture.instructions.0
            let plans = architecture.instructions.1
            let views = constructorHelper(superView: superView, query: query)
            plans?(views)
        }
    }


    static func constructorHelper(superView: UIView, query: ArchitectQuery) -> [UIView] {
        return query().reduce([superView], { result, architect in
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
    }


    static func viewForArchitect(_ architect: Architect) -> UIView {
        switch architect {
        case .view: return UIView()
        case .stackView: return UIStackView()
        case .blueprint(let arch): return viewForArchitect(arch)
        case .custom(let view): return view
        case scrollView: return UIScrollView()
        case collectionView: return UICollectionView()
        case tableView: return UITableView()
        case activityIndicator: return UIActivityIndicatorView()
        case control: return UIControl()
        case button: return UIButton()
        case segmentedControl: return UISegmentedControl()
        case slider: return UISlider()
        case stepper: return UIStepper()
        case uiswitch: return UISwitch()
        case pageControl: return UIPageControl()
        case datePicker: return UIDatePicker()
        case visualEffectView: return UIVisualEffectView()
        case imageView: return UIImageView()
        case pickerView: return UIPickerView()
        case progressView: return UIProgressView()
        case webView: return UIWebView()
        case label: return UILabel()
        case textView: return UITextView()
        case textfield: return UITextField()
        }
    }
}

extension Architect {

    var instructions : (ArchitectQuery, LayoutCommands?) {
        switch self {
        case .view(let query, let plans): return (query,plans)
        case .stackView(let query, let plans): return (query,plans)
        case .scrollView(let query, let plans): return (query,plans)
        case .collectionView(let query, let plans): return (query,plans)
        case .tableView(let query, let plans): return (query,plans)
        case .activityIndicator(let query, let plans): return (query,plans)
        case .control(let query, let plans): return (query,plans)
        case .button(let query, let plans): return (query,plans)
        case .segmentedControl(let query, let plans): return (query,plans)
        case .slider(let query, let plans): return (query,plans)
        case .stepper(let query, let plans): return (query,plans)
        case .uiswitch(let query, let plans): return (query,plans)
        case .pageControl(let query, let plans): return (query,plans)
        case .datePicker(let query, let plans): return (query,plans)
        case .visualEffectView(let query, let plans): return (query,plans)
        case .imageView(let query, let plans): return (query,plans)
        case .pickerView(let query, let plans): return (query,plans)
        case .progressView(let query, let plans): return (query,plans)
        case .webView(let query, let plans): return (query,plans)
        case .label(let query, let plans): return (query,plans)
        case .textView(let query, let plans): return (query,plans)
        case .textfield(let query, let plans): return (query,plans)
        default:
            fatalError("Blueprint and custom do not have instructions therefore they can't be used. This could also be an unhandled case please be sure to handle all cases with query and plans")
        }
    }

}
