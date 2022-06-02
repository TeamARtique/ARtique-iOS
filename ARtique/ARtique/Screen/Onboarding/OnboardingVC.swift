//
//  OnboardingVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/06/03.
//

import UIKit
import SnapKit
import Then

class OnboardingVC: BaseVC {
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var skipButton: UIButton!
    
    let onboardingCnt = 4
    var page = 0
    let scrollView = UIScrollView()
    let titles = [
        "아띠들의 전시를 둘러봐요",
        "아띠크한 전시회를 만들어요",
        "마음에 쏙 드는 전시회를 AR로 감상해요",
        "감상한 전시회의 티켓을 모아봐요"
    ]
    
    let explanations = [
        "전문 예술부터 가볍게 즐길 수 있는 전시까지\n다양한 작품들을 감상해봐요",
        "나만의 작품들을\n내가 원하는 대로 전시회를 만들어봐요",
        "나를 기준으로 동그랗게 형성된 3D 모델링 공간에서\n현실감 넘치는 AR 전시를 감상해요",
        "내가 관람한 전시들을 티켓으로 모으고\n모은 티켓을 SNS에 공유해봐요"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureScrollView()
        configurePageController()
        configureButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

//MARK: Configure
extension OnboardingVC {
    func configureScrollView() {
        holderView.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(onboardingCnt), height: 0)
        scrollView.isPagingEnabled = true
    }
    
    func configurePageController() {
        pageController.numberOfPages = onboardingCnt
        pageController.currentPage = 0
        pageController.pageIndicatorTintColor = .gray1
        pageController.currentPageIndicatorTintColor = .black
    }
    
    func configureButtons() {
        prevButton.layer.cornerRadius = prevButton.frame.height / 2
        prevButton.setImage(UIImage(named: "OnboardingPrevBtn"), for: .normal)
        prevButton.addTarget(self, action: #selector(didTapPrevButton), for: .touchUpInside)
        prevButton.isHidden = true

        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        nextButton.setImage(UIImage(named: "OnboardingNextBtn"), for: .normal)
        nextButton.backgroundColor = .black
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = .AppleSDGothicSB(size: 15)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        skipButton.setTitle("건너뛰기", for: .normal)
        skipButton.tintColor = .black
        skipButton.titleLabel?.font = .AppleSDGothicSB(size: 13)
        skipButton.addTarget(self, action: #selector(skipOnboarding), for: .touchUpInside)
    }
    
    func configureLayout() {
        for i in 0..<onboardingCnt {
            let pageView = UIStackView()
                .then {
                    $0.spacing = 20
                    $0.axis = .vertical
                }
            scrollView.addSubview(pageView)
            pageView.snp.makeConstraints {
                $0.centerY.equalToSuperview().offset(-30)
                $0.leading.equalToSuperview().offset(CGFloat(i) * screenWidth)
                $0.trailing.equalToSuperview().offset(-1 * CGFloat(onboardingCnt - 1 - i) * screenWidth)
                $0.width.equalTo(screenWidth)
            }
            
            let imageView = UIImageView()
                .then {
                    $0.contentMode = .scaleAspectFit
                    $0.image = UIImage(named: "onboarding\(i+1)")
                }
            pageView.addArrangedSubview(imageView)
            pageView.setCustomSpacing(44, after: imageView)
            
            let title = UILabel()
                .then {
                    $0.text = titles[i]
                    $0.font = .AppleSDGothicB(size: 19)
                    $0.textAlignment = .center
                }
            pageView.addArrangedSubview(title)
            
            let explanation = UILabel()
                .then {
                    $0.text = explanations[i]
                    $0.font = .AppleSDGothicL(size: 15)
                    $0.textAlignment = .center
                    $0.setLineBreakMode()
                }
            pageView.addArrangedSubview(explanation)
        }
    }
}

//MARK: Custom Methods
extension OnboardingVC {
    func setButtonChange() {
        if page == onboardingCnt - 1 {
            nextBtnWidth.constant = 88
            nextButton.setImage(nil, for: .normal)
            nextButton.setTitle("시작하기", for: .normal)
            skipButton.isHidden = true
        } else {
            nextBtnWidth.constant = 42
            nextButton.setImage(UIImage(named: "OnboardingNextBtn"), for: .normal)
            nextButton.setTitle(nil, for: .normal)
            skipButton.isHidden = false
        }
        
        prevButton.isHidden = page == 0 ? true : false
    }
    
    @objc func didTapNextButton() {
        page += 1
        guard page < onboardingCnt else {
            skipOnboarding()
            return
        }
        scrollView.setContentOffset(CGPoint(x: screenWidth * CGFloat(page), y: 0), animated: true)
    }
    
    @objc func didTapPrevButton() {
        page -= 1
        if page < 0 { return }
        scrollView.setContentOffset(CGPoint(x: screenWidth * CGFloat(page), y: 0), animated: true)
    }
    
    @objc func skipOnboarding() {
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .fullScreen
        
        self.view.window?.rootViewController?.dismiss(animated: true) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController?.present(loginVC, animated: true, completion: nil)
        }
    }
}

extension OnboardingVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / screenWidth)
        if page.isNaN || page.isInfinite { return }
        pageController.currentPage = Int(page)
        self.page = Int(page)
        setButtonChange()
    }
}
