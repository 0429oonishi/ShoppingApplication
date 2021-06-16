//
//  AdMob.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/18.
//

import GoogleMobileAds

struct AdMob {

    private let adUnitID = "ca-app-pub-5791981660348332/8471327283"

    func load(to adMobView: UIView, rootVC: UIViewController) {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = rootVC
        bannerView.load(GADRequest())
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        adMobView.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.widthAnchor.constraint(equalTo: adMobView.widthAnchor),
            bannerView.heightAnchor.constraint(equalTo: adMobView.heightAnchor),
            bannerView.centerXAnchor.constraint(equalTo: adMobView.centerXAnchor)
        ])
    }

}
