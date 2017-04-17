//
//  AddBanner.swift
//  SecretPhoto
//
//  Created by 河原圭佑 on 2017/03/20.
//  Copyright © 2017年 kawahara keisuke. All rights reserved.
//

import GoogleMobileAds

protocol AdShowable {
    
}
/*
extension AdShowable where Self: UIViewController{
    func getAdView() -> GADBannerView {
        let bannerView:GADBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - bannerView.frame.height)
        bannerView.frame.size = CGSize(width: self.view.frame.width, height: bannerView.frame.height)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        let gadRequest:GADRequest = GADRequest()
        gadRequest.testDevices = [kGADSimulatorID]  // テスト時のみ
        bannerView.load(gadRequest)
        return bannerView
    }
    
    func getAdViewOverTabBar(tabBarHeight: CGFloat) -> GADBannerView {
        let bannerView:GADBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - bannerView.frame.height - tabBarHeight)
        bannerView.frame.size = CGSize(width: self.view.frame.width, height: bannerView.frame.height)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        let gadRequest:GADRequest = GADRequest()
        gadRequest.testDevices = [kGADSimulatorID]  // テスト時のみ
        bannerView.load(gadRequest)
        return bannerView
    }

}
 */
