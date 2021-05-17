import UIKit

extension UIColor {

    var rgbString: String {
        var red = CGFloat.zero
        var green = CGFloat.zero
        var blue = CGFloat.zero
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return [red, green, blue].reduce("") { res, value in
            let intval = Int(round(value * 255))
            return res + (NSString(format: "%02X", intval) as String)
        }
    }

    convenience init(code: String) {
        var color: UInt32 = 0
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        if Scanner(string: code.replacingOccurrences(of: "#", with: "")).scanHexInt32(&color) {
            r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            b = CGFloat( color & 0x0000FF       ) / 255.0
        }
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

    var themeColor: UIColor {
        guard let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") else {
            if self == .black {
                return .black
            } else {
                return .white
            }
        }
        return UIColor(code: themeColorString)
    }

}
