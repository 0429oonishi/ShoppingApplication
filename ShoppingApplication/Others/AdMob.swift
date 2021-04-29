//
//  AdMob.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/18.
//

import GoogleMobileAds

struct AdMob {
    static let AdMobId = "ca-app-pub-5791981660348332/8471327283"

    static func addAdMobView(adMobView: UIView, width: CGFloat, height: CGFloat, viewController: UIViewController) {
        var AdMobView = GADBannerView()
        AdMobView = GADBannerView(adSize: kGADAdSizeBanner)
        AdMobView.frame.size = CGSize(width: width, height: height)
        AdMobView.adUnitID = AdMob.AdMobId
        AdMobView.rootViewController = viewController
        AdMobView.load(GADRequest())
        adMobView.addSubview(AdMobView)
    }
}
