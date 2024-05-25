//
//  SplashAnimationViewController.swift
//  MangaComic
//
//  Created by tandev on 21/5/24.
//

import UIKit
import Lottie

class SplashAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        // Tạo một Lottie Animation View với tên animation là "splash"
        let animationView = LottieAnimationView(name: "splash")

               // Đặt kích thước và vị trí của animation view
               animationView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
               animationView.center = self.view.center

               // Đặt các thuộc tính khác cho animation view nếu cần
               animationView.contentMode = .scaleAspectFit

               // Thêm animation view vào view controller
               self.view.addSubview(animationView)

               // Bắt đầu animation
               animationView.play { (finished) in
                   
                   // Chuyển đến MainViewController sau khi animation kết thúc
                                  DispatchQueue.main.async {
                                      let storyboard = UIStoryboard(name: "Main", bundle: nil) // Thay "Main" bằng tên storyboard của bạn nếu khác
                                      let mainViewController = storyboard.instantiateViewController(withIdentifier: "navigationbarID")
                                      
                                      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                                      windowScene.windows.first?.rootViewController = mainViewController
                                  }
               }
        
      
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
