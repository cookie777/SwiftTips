//
//  CustomClassViewController.swift
//  DynamicSizeScrollView
//
//  Created by Takayuki Yamaguchi on 2021-06-19.
//

import UIKit

class CustomClassViewController: UIViewController {
  
  let contentView: UIView = {
    let lb = UILabel()
    lb.numberOfLines = 0
    lb.translatesAutoresizingMaskIntoConstraints = false
    
    lb.text = """
      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quis risus sed vulputate odio. Sed adipiscing diam donec adipiscing tristique risus nec. Sit amet consectetur adipiscing elit. Sit amet nisl purus in. Blandit volutpat maecenas volutpat blandit aliquam etiam erat velit scelerisque. Faucibus turpis in eu mi. Auctor augue mauris augue neque gravida in. Tortor at risus viverra adipiscing at in tellus integer feugiat. Arcu ac tortor dignissim convallis aenean et tortor at. Aliquet porttitor lacus luctus accumsan tortor posuere ac.

      A cras semper auctor neque vitae tempus. Ut tortor pretium viverra suspendisse potenti nullam ac. Suspendisse faucibus interdum posuere lorem ipsum dolor sit amet consectetur. Nullam ac tortor vitae purus faucibus ornare suspendisse sed. Enim sed faucibus turpis in eu mi bibendum neque. Tincidunt praesent semper feugiat nibh sed pulvinar. Augue eget arcu dictum varius duis at consectetur. Morbi non arcu risus quis varius quam quisque. Proin libero nunc consequat interdum varius sit. Diam maecenas ultricies mi eget mauris.

      Convallis posuere morbi leo urna. Purus in mollis nunc sed. Senectus et netus et malesuada fames. Massa ultricies mi quis hendrerit dolor magna eget est lorem. Pharetra magna ac placerat vestibulum lectus. Egestas erat imperdiet sed euismod nisi porta lorem. Sed odio morbi quis commodo odio aenean sed adipiscing diam. Eget est lorem ipsum dolor sit amet consectetur adipiscing elit. Est lorem ipsum dolor sit amet consectetur. Hac habitasse platea dictumst quisque sagittis purus sit amet. Eget nunc scelerisque viverra mauris. Curabitur gravida arcu ac tortor. Interdum velit euismod in pellentesque massa placerat duis ultricies lacus. Quis commodo odio aenean sed adipiscing diam donec adipiscing. Pellentesque pulvinar pellentesque habitant morbi tristique senectus et. Egestas purus viverra accumsan in nisl nisi scelerisque eu ultrices. Egestas sed sed risus pretium quam vulputate dignissim suspendisse. Facilisi nullam vehicula ipsum a arcu cursus. Consectetur libero id faucibus nisl. Diam quis enim lobortis scelerisque fermentum.

      Pellentesque dignissim enim sit amet venenatis urna cursus eget nunc. Odio ut enim blandit volutpat maecenas volutpat. Nisi est sit amet facilisis magna etiam tempor orci eu. Dolor magna eget est lorem ipsum. Tempor id eu nisl nunc. Non consectetur a erat nam at lectus urna duis. Hendrerit gravida rutrum quisque non tellus. Enim ut tellus elementum sagittis vitae et leo. Gravida arcu ac tortor dignissim. Mauris sit amet massa vitae tortor condimentum lacinia quis vel. Vivamus at augue eget arcu dictum. Elementum curabitur vitae nunc sed velit. Neque viverra justo nec ultrices dui sapien eget mi. Integer malesuada nunc vel risus commodo viverra. Nulla malesuada pellentesque elit eget gravida cum. Aliquam vestibulum morbi blandit cursus risus at ultrices mi. Consectetur adipiscing elit ut aliquam purus sit amet. Aliquam sem fringilla ut morbi tincidunt augue interdum. Elementum tempus egestas sed sed. Commodo viverra maecenas accumsan lacus.

      Libero justo laoreet sit amet cursus sit. Amet mauris commodo quis imperdiet massa tincidunt nunc pulvinar. Leo duis ut diam quam nulla porttitor massa. Ultricies tristique nulla aliquet enim tortor at auctor. Turpis massa tincidunt dui ut ornare. Vitae et leo duis ut. Nunc sed velit dignissim sodales ut. Ut venenatis tellus in metus vulputate eu scelerisque. Sit amet nisl suscipit adipiscing. Arcu bibendum at varius vel. Elementum nibh tellus molestie nunc non blandit. Laoreet sit amet cursus sit amet dictum. Ac ut consequat semper viverra nam libero justo. Vulputate dignissim suspendisse in est ante. Id cursus metus aliquam eleifend mi in nulla. Ullamcorper eget nulla facilisi etiam dignissim diam. Et egestas quis ipsum suspendisse ultrices gravida.
      """
    
    return lb
  }()
  
  lazy var scrollView = DynamicHeightScrollView(
    contentView: contentView,
    padding: .init(top: 32, left: 32, bottom: 32, right: 32)
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    scrollView.backgroundColor = .systemBackground
    view.addSubview(scrollView)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
}
