//
//  OnboardingViewController.swift
//  BlindWays
//
//  Created by Zev Eisenberg on 5/23/16.
//  Copyright© 2016 Perkins School for the Blind
//
//  All "Perkins Bus Stop App" Software is licensed under Apache Version 2.0.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Anchorage
import CoreLocation
import BoardingPass

final class OnboardingViewController: UIViewController {

    // Private Properties

    fileprivate let client: APIClient
    fileprivate var pages: [OnboardingPage]!

    fileprivate let boardingNavController: UINavigationController = {
        let vc = BoardingNavigationController()
        vc.isNavigationBarHidden = true
        return vc
    }()

    /// Wrap video and gradient overlays in a view so their alpha can be adjusted post-composite,
    /// which makes fade animations smoother because the video's apparent brightness doesn't
    /// go up and then dip back down as the gradients fade in.
    fileprivate let videoAndGradientWrapper = UIView("videoAndGradientWrapper")

    // PLACEHOLDER - To add an background video that will play behind the onboariding process,
    // add a .mp4 or .m4v file named "onboarding" to the xcode project. The video should have a
    // 9:16 aspect ratio (the original video is 608 pixels wide and 1080 pixels tall)
    fileprivate let videoView = LoopingVideoView(videoURL: Bundle.main.url(forResource: "onboarding", withExtension: "mp4") ?? Bundle.main.url(forResource: "onboarding", withExtension: "m4v"))
    fileprivate let topGradient = GradientView("topGradient")
    fileprivate let bottomGradient = GradientView("bottomGradient")
    fileprivate let bottomDarkSpacer = UIView("bottomDarkSpacer")
    fileprivate var currentIndex: Int?
    fileprivate var currentlyTransitioning = false

    fileprivate var locationManager: CLLocationManager?

    init(client: APIClient) {
        self.client = client
        super.init(nibName: nil, bundle: nil)
        pages = OnboardingViewController.onboardingPages(parent: self)

        videoView.videoGravity = .aspectFill

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(OnboardingViewController.registeredUserNotifications),
            name: Notification.Name(AppDelegate.NotificationName.registeredUserNotificationSettings),
            object: nil
        )
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView("OnboardingViewController")
        view.backgroundColor = Colors.Common.marineBlue

        view.addSubview(videoAndGradientWrapper)
        videoAndGradientWrapper.addSubview(videoView)
        videoAndGradientWrapper.addSubview(topGradient)
        videoAndGradientWrapper.addSubview(bottomGradient)
        videoAndGradientWrapper.addSubview(bottomDarkSpacer)

        videoAndGradientWrapper.alpha = 0.0

        topGradient.direction = .down
        bottomGradient.direction = .up

        let black = Colors.Common.black
        let clearBlack = black.withAlphaComponent(0.0)
        let colors = (start: black, end: clearBlack)
        topGradient.colors = colors
        bottomGradient.colors = colors

        bottomDarkSpacer.backgroundColor = black

        topGradient.alpha = Layout.topGradientAlpha
        bottomGradient.alpha = Layout.bottomGradientAlpha
        bottomDarkSpacer.alpha = Layout.bottomGradientAlpha
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        videoAndGradientWrapper.edgeAnchors == view.edgeAnchors

        videoView.edgeAnchors == videoAndGradientWrapper.edgeAnchors

        topGradient.topAnchor == view.topAnchor
        topGradient.horizontalAnchors == view.horizontalAnchors
        topGradient.heightAnchor == Layout.topGradientHeight

        bottomGradient.horizontalAnchors == view.horizontalAnchors
        bottomGradient.heightAnchor == Layout.bottomGradientHeight

        bottomDarkSpacer.horizontalAnchors == view.horizontalAnchors
        bottomDarkSpacer.heightAnchor == Layout.bottomDarkSpacerHeight
        bottomDarkSpacer.topAnchor == bottomGradient.bottomAnchor
        bottomDarkSpacer.bottomAnchor == view.bottomAnchor

        rz_addChildViewController(boardingNavController, inView: view)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if currentIndex == nil {
            showNextViewController()
        }

        UIView.animate(withDuration: Layout.videoFadeInDuration, animations: {
            self.videoAndGradientWrapper.alpha = 1.0
        })
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        videoView.stop()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: - Private

private extension OnboardingViewController {

    struct Layout {

        static let welcomeVerticalSpacing = CGFloat(43.0)
        static let otherVerticalSpacing = CGFloat(18.0)
        static let topGradientHeight = CGFloat(56.0)
        static let bottomGradientHeight = CGFloat(128.0)
        static let bottomDarkSpacerHeight = CGFloat(128.0)
        static let topGradientAlpha = CGFloat(0.5)
        static let bottomGradientAlpha = CGFloat(0.66)
        static let videoFadeInDuration = TimeInterval(1.0)
        static func delayBeforeShowingNextScreen() -> TimeInterval {
            return Accessibility.isVoiceOverRunning() ? 0.0 : TimeInterval(0.7)
        }

    }

    func showNextViewController() {
        if currentlyTransitioning {
            return
        }

        if let index = currentIndex {
            let upcomingPages = pages.suffix(from: (index + 1))
            currentIndex = upcomingPages.index { $0.shouldShow() }
        } else {
            currentIndex = pages.startIndex
        }

        guard let index = currentIndex else {
            // There are no more pages left to show, so bail early
            return
        }

        let newPageVC = OnboardingPageViewController(page: pages[index])

        // Don't animate the first page
        let animated = (boardingNavController.viewControllers.count != 0)

        boardingNavController.pushViewController(newPageVC, animated: animated)

        if animated {
            currentlyTransitioning = true
            boardingNavController.transitionCoordinator?.animate(alongsideTransition: nil, completion: { _ in
                self.currentlyTransitioning = false
            })
        }
    }

    static func onboardingPages(parent: OnboardingViewController?) -> [OnboardingPage] {

        return { [weak parent] in
            let welcomePage = OnboardingPage(
                shouldShow: {
                    return !Defaults.shared.read(UserDefaultsKeys.hasSeenOnboarding)
                },
                mainText: UIStrings.onboardingMainMessageWelcomeScreen,
                primaryAction: (title: UIStrings.onboardingMainActionTitleWelcomeScreen, action: {
                    parent?.showNextViewController()
                }),
                secondaryAction: nil,
                tertiaryAction: nil,
                verticalSpacing: Layout.welcomeVerticalSpacing
            )

            let locationPage = OnboardingPage(
                shouldShow: {
                    return GeoLocator.authorizationStatus != .yes
                },
                mainText: UIStrings.onboardingMainMessageLocationScreen,
                primaryAction: (title: UIStrings.onboardingMainActionTitleLocationScreen, action: {
                    parent?.locationManager = CLLocationManager()
                    parent?.locationManager?.delegate = parent
                    parent?.locationManager?.requestWhenInUseAuthorization()
                }),
                secondaryAction: (title: UIStrings.onboardingSecondaryActionTitleSkip, action: {
                    parent?.showNextViewController()
                }),
                tertiaryAction: nil,
                verticalSpacing: Layout.otherVerticalSpacing
            )

            let notificationsPage = OnboardingPage(
                shouldShow: {
                    return !Defaults.shared.read(UserDefaultsKeys.hasSeenNotificationPrompt)
                },
                mainText: UIStrings.onboardingMainMessageNotificationsScreen,
                primaryAction: (title: UIStrings.onboardingMainActionTitleNotificationsScreen, action: {
                    FirebaseService.registerForPush()
                }),
                secondaryAction: (title: UIStrings.onboardingSecondaryActionTitleSkip, action: {
                    parent?.showNextViewController()
                }),
                tertiaryAction: nil,
                verticalSpacing: Layout.otherVerticalSpacing
            )

            let joinPage = OnboardingPage(
                shouldShow: { return true },
                mainText: UIStrings.onboardingMainMessageJoinScreen,
                primaryAction: (title: UIStrings.onboardingMainActionTitleJoinScreen, action: {
                    if let parent = parent {
                        Defaults.shared.write(true, forKey: UserDefaultsKeys.hasSeenOnboarding)
                        let viewModel = SignUpViewModel(client: parent.client)
                        let authVC = AuthViewController(viewModel: viewModel, onSuccessBlock: {
                            AppDelegate.shared.presentMainAnimated(true)
                        })
                        let nav = UINavigationController(rootViewController: authVC)
                        parent.present(nav, animated: true, completion: nil)
                    }
                }),
                secondaryAction: (title: UIStrings.onboardingSecondaryActionTitleJoinScreen, action: {
                    if let parent = parent {
                        Defaults.shared.write(true, forKey: UserDefaultsKeys.hasSeenOnboarding)
                        let viewModel = SignInViewModel(client: parent.client)
                        let authVC = AuthViewController(viewModel: viewModel, onSuccessBlock: {
                            AppDelegate.shared.presentMainAnimated(true)
                        })
                        let nav = UINavigationController(rootViewController: authVC)
                        parent.present(nav, animated: true, completion: nil)
                    }
                }),
                tertiaryAction: (title: UIStrings.onboardingTertiaryActionTitleJoinScreen, action: {
                    Defaults.shared.write(true, forKey: UserDefaultsKeys.hasSeenOnboarding)
                    AppDelegate.shared.apiClient.configuration.configureReadToken()
                    AppDelegate.shared.presentMainAnimated(true)
                }),
                verticalSpacing: Layout.otherVerticalSpacing
            )

            return [
                welcomePage,
                locationPage,
                notificationsPage,
                joinPage,
            ]
            }()
    }

}

// MARK: - Notifications

private extension OnboardingViewController {

    @objc func registeredUserNotifications() {
        Utility.performAfter(Layout.delayBeforeShowingNextScreen()) {
            self.showNextViewController()
        }
    }

}

// MARK: - CLLocationManagerDelegate

extension OnboardingViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
            locationManager = nil
            Utility.performAfter(Layout.delayBeforeShowingNextScreen()) {
                self.showNextViewController()
            }
        }
    }

}
