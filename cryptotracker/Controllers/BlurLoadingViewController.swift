import UIKit
import Lottie

class BlurLoadingViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissFade() {
        self.unblur()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            
            self?.blur()
            
//            let animationView = LOTAnimationView(name: "gears")
//            view.addSubview(animationView)
//            animationView.play()
//            animationView.loopAnimation = true
//
//            animationView.centerAnchors == view.centerAnchors
            
            //Create Activity Indicator
//            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//
//            // Position Activity Indicator in the center of the main view
//            myActivityIndicator.center = self?.view.center ?? CGPoint()
//
//            // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
//            myActivityIndicator.hidesWhenStopped = false
//
//            // Start Activity Indicator
//            myActivityIndicator.startAnimating()
//
//            // Call stopAnimating() when need to stop activity indicator
//            //myActivityIndicator.stopAnimating()
            
            
//            self?.view.addSubview(myActivityIndicator)
        }
    }
}
