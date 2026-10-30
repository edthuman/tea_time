import CoreFoundation
import SwiftUI

func getListHeight(_ screenHeight: CGFloat) -> CGFloat {
    return screenHeight > 400 ? screenHeight - 35 : screenHeight - 45
}

func getAddButtonPadding(_ screenHeight: CGFloat) -> CGFloat {
    return screenHeight < 400 ? 10 : 0
}

func getCommandBarPadding(_ verticalSizeClass: UserInterfaceSizeClass?) -> CGFloat {
    guard let verticalSizeClass else {
        return CGFloat(0)
    }
    
    return verticalSizeClass == UserInterfaceSizeClass.compact
        ? CGFloat(10)
        : CGFloat(0)
}
