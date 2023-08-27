//
//  TextView.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 13/08/2023.
//

import SwiftUI

enum TextViewType {
    case h1Type
    case h2Type
    case h3Type
    case h4Type
    case h5Type
    case h6Type
    case subtitle1
    case subtitle2
    case body1
    case body2
    case button
    case caption
    case overline
}

struct TextView: View {
    var text: String
    var type: TextViewType
    var lineLimit: Int = 0
    var body: some View {
        switch type {
        case .h1Type:
                return Text(text)
                    .tracking(-1.5)
                    .modifier(InterFont(.bold, size: 96))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .h2Type:
                return Text(text)
                    .tracking(-0.5)
                    .modifier(InterFont(.bold, size: 60))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .h3Type:
                return Text(text)
                    .tracking(0)
                    .modifier(InterFont(.bold, size: 48))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .h4Type:
                return Text(text)
                    .tracking(0.25)
                    .modifier(InterFont(.bold, size: 34))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .h5Type:
                return Text(text)
                    .tracking(0)
                    .modifier(InterFont(.semiBold, size: 24))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .h6Type:
                return Text(text)
                    .tracking(0.15)
                    .modifier(InterFont(.semiBold, size: 20))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .subtitle1:
                return Text(text)
                    .tracking(0.15)
                    .modifier(InterFont(.bold, size: 16))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .subtitle2:
                return Text(text)
                    .tracking(0.1)
                    .modifier(InterFont(.bold, size: 14))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .body1:
                return Text(text)
                    .tracking(0.5)
                    .modifier(InterFont(.regular, size: 16))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .body2:
                return Text(text)
                    .tracking(0.25)
                    .modifier(InterFont(.regular, size: 14))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .button:
                return Text(text)
                    .tracking(1.25)
                    .modifier(InterFont(.semiBold, size: 14))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .caption:
                return Text(text)
                    .tracking(0.4)
                    .modifier(InterFont(.medium, size: 12))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .overline:
                return Text(text)
                    .tracking(1.5)
                    .modifier(InterFont(.semiBold, size: 10))
                    .lineLimit(lineLimit == 0 ? .none : lineLimit)
        }
    }
}
