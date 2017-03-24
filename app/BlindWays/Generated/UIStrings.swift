// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable type_body_length
enum UIStrings {
  /// An error occurred while attempting to access this data.
  case emptyStateGenericError
  /// There were no results found.
  case emptyStateGenericNoData
  /// There is a problem connecting to the internet.
  case emptyStateGenericNoInternet
  /// An unknown error has occurred
  case errorUnknownMessage
  /// Cancel
  case commonCancel
  /// Close
  case commonClose
  /// Done
  case commonDone
  /// OK
  case commonOk
  /// On
  case commonOn
  /// Off
  case commonOff
  /// Submit
  case commonSubmit
  /// Success
  case commonSuccess
  /// Problem
  case commonProblem
  /// Try Again
  case commonTryAgain
  /// Refresh
  case commonRefresh
  /// Continue
  case commonContinue
  /// Now
  case commonNow
  /// %@…
  case commonTruncation(String)
  /// Dismiss
  case commonDismiss
  /// %1$@ %2$@
  case commonConcatenateTwoSentences(String, String)
  /// There is already an account with that email address. Did you try signing in?
  case errorEmailAlreadyInUse
  /// The email and password you entered do not match. Please try again.
  case errorInvalidCredentials
  /// BlindWays picks up where GPS leaves off, closing the gap for riders with visual impairments.
  case onboardingMainMessageWelcomeScreen
  /// We use location to connect you to relevant bus stops.
  case onboardingMainMessageLocationScreen
  /// We’ll notify you about real time developments and opportunities to help.
  case onboardingMainMessageNotificationsScreen
  /// Identify landmarks around bus stops to give fellow riders confidence and independence.
  case onboardingMainMessageJoinScreen
  /// Continue
  case onboardingMainActionTitleWelcomeScreen
  /// Enable Location
  case onboardingMainActionTitleLocationScreen
  /// Enable Notifications
  case onboardingMainActionTitleNotificationsScreen
  /// Join the Community
  case onboardingMainActionTitleJoinScreen
  /// <bold>Skip for now</bold>
  case onboardingSecondaryActionTitleSkip
  /// Already have an account? <bold>Sign<BON:noBreakSpace/>in.</bold>
  case onboardingSecondaryActionTitleJoinScreen
  /// Join later
  case onboardingTertiaryActionTitleJoinScreen
  /// Join the Community
  case signupTitle
  /// Email
  case signupEmailTitle
  /// Enter your email address
  case signupEmailPlaceholder
  /// Password
  case signupPasswordTitle
  /// Create a password (8+ characters)
  case signupPasswordPlaceholder
  /// Already have an account? <bold>Sign in.</bold>
  case signupAlreadyHaveAccountTitle
  /// Creating your account
  case signupAccessibilitySavingMessage
  /// Sign In
  case signinTitle
  /// Please sign in
  case signinHeader
  /// Email
  case signinEmailTitle
  /// Enter your email address
  case signinEmailPlaceholder
  /// Password
  case signinPasswordTitle
  /// Enter your password
  case signinPasswordPlaceholder
  /// Forgot password?
  case signinForgotPasswordButtonTitle
  /// Signing in
  case signinAccessibilitySavingMessage
  /// Forgot Password
  case signinForgotPasswordAlertTitle
  /// Enter the email address associated with your account, and we’ll send you an email with instructions on how to reset your password.
  case signinForgotPasswordAlertMessage
  /// We’ve sent an email to %@ with instructions on how to reset your password.
  case signinForgotPasswordAlertSuccessMessage(String)
  /// Menu
  case settingsTitle
  /// Account
  case settingsSectionTitleAccount
  /// Sign In
  case settingsSignIn
  /// Join the Community
  case settingsSignUp
  /// Email
  case settingsEmail
  /// Password
  case settingsPassword
  /// Change Password
  case settingsChangePassword
  /// Bus Service
  case settingsAgency
  /// Location Services
  case settingsLocationServices
  /// Notifications
  case settingsNotifications
  /// Navigation Helper
  case settingsNavigationHelper
  /// About BlindWays
  case settingsSectionTitleAbout
  /// More Info
  case settingsAbout
  /// Share
  case settingsShare
  /// Rate
  case settingsRate
  /// Send Feedback
  case settingsFeedback
  /// Sign Out
  case settingsSignOut
  /// Delete Account
  case settingsDeleteAccount
  /// Are you sure you want to sign out?
  case settingsSignOutAlertMessage
  /// Download the @PerkinsVision #BlindWays app and help bus riders who are blind travel confidently and independently.
  case settingsShareMessage
  /// Choose
  case settingsNavigationHelperNotSet
  /// We’ll use this app to route you to bus stops that are not nearby.
  case settingsNavigationHelperHint
  /// Which app would you like to use when navigating over longer distances?
  case settingsNavigationHelperSelectMessage
  /// Change Email
  case settingsChangeEmailAlertTitle
  /// Change your email address and tap “Submit”
  case settingsChangeEmailAlertMessage
  /// Enter email address
  case settingsChangeEmailAlertPlaceholder
  /// Email Changed
  case settingsChangeEmailAlertSuccessTitle
  /// Your email has been changed to %@.
  case settingsChangeEmailAlertSuccessMessage(String)
  /// Change Password
  case settingsChangePasswordAlertTitle
  /// Enter your current password and a new password, then tap “Submit”
  case settingsChangePasswordAlertMessage
  /// Current Password
  case settingsChangePasswordOldFieldName
  /// New Password
  case settingsChangePasswordNewFieldName
  /// Current password
  case settingsChangePasswordAlertOldPlaceholder
  /// New password (min 8 characters)
  case settingsChangePasswordAlertNewPlaceholder
  /// Password Changed
  case settingsChangePasswordAlertSuccessTitle
  /// Your password has been changed.
  case settingsChangePasswordAlertSuccessMessage
  /// Incorrect Password
  case settingsChangePasswordAlertFailureTitle
  /// The existing password you entered was incorrect.
  case settingsChangePasswordAlertFailureMessage
  /// Delete Account
  case settingsDeleteAccountAlertButtonTitle
  /// Deleting your account will remove your ability to add any more clues or see any data about the clues you’ve already added. Note: This will NOT remove the clues you have already provided.
  case settingsDeleteAccountAlertMessage
  /// About BlindWays
  case settingsAboutTitle
  /// Founded in 1829 as the first U.S. school of its kind, Perkins works globally to help children and adults who are blind reach their full potential through education and innovation.
  case settingsAboutPerkins
  /// Learn More at Perkins.org
  case settingsAboutLearnMore
  /// Acknowledgements
  case settingsAboutAcknowledgements
  /// Terms & Conditions
  case settingsAboutTerms
  /// BlindWays is a trademark of Perkins School for the Blind. © 2016 Perkins School for the Blind
  case settingsAboutCopyrightFooter
  /// Choose a Bus Service
  case agenciesTitle
  /// Other Service Areas
  case agenciesOtherServiceAreas
  /// It looks like you have changed cities. Would you like to use the nearby bus service?
  case agenciesDescriptionChanged
  /// Which nearby bus service would you like to use?
  case agenciesDescriptionNearby
  /// Which supported bus service would you like to use?
  case agenciesDescriptionSupported
  /// There were no agencies found.
  case agenciesEmptyStateNoResults
  /// Select a Bus Stop
  case stopsTitle
  /// Nearby
  case stopsBackButtonTitleNearby
  /// Saved
  case stopsBackButtonTitleSaved
  /// Refresh Stops
  case stopsRefreshButtonTitle
  /// Loading: %@
  case stopsAccessibilityRefreshingTitle(String)
  /// Done loading stops, %d results.
  case stopsAccessibilityDidRefreshTitle(Int)
  /// Nearby stops
  case stopsNearbyTitle
  /// Saved stops
  case stopsSavedTitle
  /// Route
  case stopsCellRouteTitle
  /// Routes
  case stopsCellRoutesTitle
  /// %d Routes
  case stopsCellRoutesTitleFormat(Int)
  /// More Clues Needed
  case stopsCellNeedsMoreCluesTitle
  /// There were no stops found.
  case stopsEmptyStateNoResults
  /// There are no bus stops nearby.
  case stopsEmptyStateNoNearby
  /// You have not saved any stops. You can save a stop via the stop detail screen.
  case stopsEmptyStateNoSaved
  /// Location services are required to identify nearby stops.
  case stopsEmptyStateLocationServicesDisabled
  /// Location Settings
  case stopsEmptyStateLocationSettings
  /// Enable Location Services
  case stopsEmptyStateEnableLocation
  /// Arrivals
  case stopsArrivalsTitle
  /// %d min
  case stopsArrivalsMinutesLabelFormat(Int)
  /// Route %@
  case stopsArrivalsRouteLabelFormat(String)
  /// There are currently no arrival times available for this route.
  case stopsArrivalsEmptyStateNoData
  /// Refreshing arrival times
  case stopsArrivalsAccessibilityRefreshingTitle
  /// Done refreshing arrival times, %d results.
  case stopsArrivalsAccessibilityDidRefreshTitle(Int)
  /// Refreshing in %@ second
  case stopsArrivalsNextRefreshingSingularSecondsFormat(String)
  /// Refreshing in %@ seconds
  case stopsArrivalsNextRefreshingPluralSecondsFormat(String)
  /// Loading stop details.
  case stopDetailAccessibilityLoadingTitle
  /// Checking arrival times…
  case stopDetailArrivalsLoadingTitle
  /// This may take a few seconds.
  case stopDetailArrivalsLoadingSubtitle
  /// No upcoming bus arrivals.
  case stopDetailArrivalsNoResultsTitle
  /// Check back later.
  case stopDetailArrivalsNoResultsSubtitle
  /// Next bus in %d min.
  case stopDetailArrivalsTitle(Int)
  /// Next bus arriving now.
  case stopDetailArrivalsTitleNow
  /// Route %@ to %@
  case stopDetailArrivalsSubtitle(String, String)
  /// Acquiring your location…
  case stopDetailLocationFetchingTitle
  /// This may take a few seconds.
  case stopDetailLocationFetchingSubtitle
  /// GPS accuracy is bad.
  case stopDetailLocationAccuracyBad
  /// GPS accuracy is fair.
  case stopDetailLocationAccuracyFair
  /// GPS accuracy is good.
  case stopDetailLocationAccuracyGood
  /// You are within %d ft.
  case stopDetailLocationWithinFt(Int)
  /// You are within %d m.
  case stopDetailLocationWithinM(Int)
  /// You are %@ mi away.
  case stopDetailLocationMiAway(String)
  /// You are %@ km away.
  case stopDetailLocationKmAway(String)
  /// Get Directions
  case stopDetailLocationNavigateSubtitle
  /// Show map
  case stopDetailLocationShowMapSubtitle
  /// Navigate to Stop
  case stopDetailLocationNavigatePromptTitle
  /// Which app would you like to use to navigate to %@?
  case stopDetailLocationNavigatePromptSubtitle(String)
  /// Apple Maps
  case stopDetailLocationNavigateAppNameApple
  /// BlindSquare
  case stopDetailLocationNavigateAppNameBlindsquare
  /// Google Maps
  case stopDetailLocationNavigateAppNameGoogle
  /// Location services are not enabled.
  case stopDetailLocationDisabledTitle
  /// Tap to go to location settings.
  case stopDetailLocationDisabledSubtitle
  /// Tap to enable location services.
  case stopDetailLocationDisabledEnableSubtitle
  /// Remove Saved Stop
  case stopDetailAccessibilityStopSavedTitle
  /// Double tap to remove from your saved stops.
  case stopDetailAccessibilityStopSavedHint
  /// Save Stop
  case stopDetailAccessibilityStopSaveTitle
  /// Double tap to save to your stops.
  case stopDetailAccessibilityStopSaveHint
  /// Double tap for more arrivals
  case stopDetailAccessibilityArrivalsAction
  /// Current Location
  case stopDetailAccessibilityLocationIconLabel
  /// Before the stop
  case stopDetailCluesetPrefixBefore
  /// Closer to the stop
  case stopDetailCluesetPrefixCloser
  /// The bus stop sign is
  case stopDetailCluesetPrefixBusStopSign
  /// Beyond the stop
  case stopDetailCluesetPrefixBeyond
  /// Further past the stop
  case stopDetailCluesetPrefixFurtherPast
  /// To the far left of the stop
  case stopDetailCluesetReviewPrefixFarLeft
  /// To the near left
  case stopDetailCluesetReviewPrefixNearLeft
  /// The bus stop sign is
  case stopDetailCluesetReviewPrefixBusStop
  /// To the near right of the stop
  case stopDetailCluesetReviewPrefixNearRight
  /// To the far right
  case stopDetailCluesetReviewPrefixFarRight
  /// No clue before the stop
  case stopDetailCluesetAccessibilityEmptyBefore
  /// No clue closer to the stop
  case stopDetailCluesetAccessibilityEmptyCloser
  /// No clue at the bus stop sign
  case stopDetailCluesetAccessibilityEmptyBusStopSign
  /// No clue beyond the stop
  case stopDetailCluesetAccessibilityEmptyBeyond
  /// No clue further past the stop
  case stopDetailCluesetAccessibilityEmptyFurtherPast
  /// No clue to the far left of the stop
  case stopDetailCluesetAccessibilityEmptyReviewFarLeft
  /// No clue to the near left
  case stopDetailCluesetAccessibilityEmptyReviewNearLeft
  /// No clue at the bus stop sign
  case stopDetailCluesetAccessibilityEmptyReviewBusStop
  /// No clue to the near right of the stop
  case stopDetailCluesetAccessibilityEmptyReviewNearRight
  /// No clue to the far right
  case stopDetailCluesetAccessibilityEmptyReviewFarRight
  /// The bus stop sign
  case stopDetailCluesetPrefixBusStopEmpty
  /// no clue was provided
  case stopDetailCluesetReviewEmptySuffix
  /// Add Clue
  case stopDetailAddClueButtonTitle
  /// Edit Clue
  case stopDetailEditClueButtonTitle
  /// Bus stop sign
  case stopDetailClueBusStopSignTitle
  /// No clue available, double tap to add a clue.
  case stopDetailAccessibilityAddClueHint
  /// Confirm Clue
  case stopDetailClueActionsConfirmTitle
  /// Rate as Helpful
  case stopDetailClueActionsRateHelpfulTitle
  /// Report a Problem
  case stopDetailClueActionsReportProblemTitle
  /// Edit Clue
  case stopDetailClueActionsEditClueTitle
  /// Delete Clue
  case stopDetailClueActionsDeleteClueTitle
  /// Confirmed!
  case stopDetailClueActionsThanksTitle
  /// Thank you for helping riders feel confident that they’re in the right place.
  case stopDetailClueActionsConfirmThanksMessage
  /// We sincerely thank you for reporting a problem with this clue. We’ll have someone look into resolving the issue as soon as possible.
  case stopDetailClueActionsReportProblemThanksMessage
  /// Physical clues help riders orient to the environment and feel confident that they’re in the right place.
  case stopDetailCluesetEmptyStateNoCluesMessage
  /// Add Clues
  case stopDetailCluesetEmptyStateNoCluesActionTitle
  /// Change
  case stopDetailCluesetHeaderChangeButtonTitle
  /// Double tap to change direction.
  case stopDetailCluesetHeaderAccessibilityChangeButtonHint
  /// Approaching the stop with the street on your <underline>left.</underline>
  case stopDetailCluesetHeaderApproachingLeft
  /// Approaching the stop with the street on your <underline>right.</underline>
  case stopDetailCluesetHeaderApproachingRight
  /// Far left clue
  case stopDetailEditCluesetClueHeaderTitleFarLeft
  /// Near left clue
  case stopDetailEditCluesetClueHeaderTitleNearLeft
  /// Bus stop clue
  case stopDetailEditCluesetClueHeaderTitleBusStop
  /// Near right clue
  case stopDetailEditCluesetClueHeaderTitleNearRight
  /// Far right clue
  case stopDetailEditCluesetClueHeaderTitleFarRight
  /// Add Clues
  case stopDetailEditCluesetTitleAdd
  /// Edit Clues
  case stopDetailEditCluesetTitleEdit
  /// Tip
  case stopDetailEditCluesetSectionHeaderTipButtontitle
  /// Please face the street where the bus will be stopping.
  case stopDetailEditCluesetSectionHeaderClueTitle
  /// Every bus stop is unique.
  case stopDetailEditCluesetSectionHeaderClueSignTitle
  /// What is the <bold>second</bold> landmark to the <bold>left</bold> of the bus stop sign?
  case stopDetailEditCluesetSectionHeaderDetailLeftFar
  /// What is the <bold>first</bold> landmark to the <bold>left</bold> of the bus stop sign?
  case stopDetailEditCluesetSectionHeaderDetailLeftNear
  /// <semibold>Please tell us about the bus stop sign.</semibold>
  case stopDetailEditCluesetSectionHeaderDetailBusStopSign
  /// What is the <bold>first</bold> landmark to the <bold>right</bold> of the bus stop sign?
  case stopDetailEditCluesetSectionHeaderDetailRightNear
  /// What is the <bold>second</bold> landmark to the <bold>right</bold> of the bus stop sign?
  case stopDetailEditCluesetSectionHeaderDetailRightFar
  /// On grass or dirt
  case stopDetailEditCluesetFieldOnGrassTitle
  /// Along the curb
  case stopDetailEditCluesetFieldAlongCurbTitle
  /// 5+ feet away from the curb
  case stopDetailEditCluesetFieldAwayFromCurbImperialTitle
  /// 1.5+ meters away from the curb
  case stopDetailEditCluesetFieldAwayFromCurbMetricTitle
  /// Enter details that help locate the bus stop sign
  case stopDetailEditCluesetFieldBusSignHintTitle
  /// %1$@ %2$@
  case stopDetailCluesetPlacementInitialFormatBusStopSign(String, String)
  /// %1$@, %2$@
  case stopDetailCluesetPlacementInitialFormatGeneric(String, String)
  /// , %@
  case stopDetailCluesetPlacementSubsequentFormat(String)
  /// OTHER • %d characters
  case stopDetailEditCluesetSectionHeaderOtherFormat(Int)
  /// DESCRIPTION • %d characters
  case stopDetailEditCluesetSectionHeaderDescriptionFormat(Int)
  /// PLACEMENT
  case stopDetailEditCluesetSectionHeaderPlacementTitle
  /// Thank you
  case stopDetailEditCluesetThanksTitle
  /// You are helping real people get where they need to go!
  case stopDetailEditCluesetThanksMessage
  /// Other Clue
  case stopDetailEditCluesetOtherAlertTitle
  /// Briefly describe the landmark. Avoid temporary landmarks like traffic cones. Example: “there are recycling bins.”
  case stopDetailEditCluesetOtherAlertMessage
  /// There is/are…
  case stopDetailEditCluesetOtherAlertPlaceholder
  /// There was a problem encountered while trying to save your clues.
  case stopDetailEditCluesetSaveErrorMessage
  /// There was a problem encountered while trying to delete this clue.
  case stopDetailDeleteClueSaveErrorMessage
  /// Clue successfully deleted.
  case stopDetailDeleteClueAccessibilitySuccessMessage
  /// Discard Changes
  case stopDetailEditCluesetUnsavedChangesDiscardTitle
  /// Save Changes
  case stopDetailEditCluesetUnsavedChangesSaveTitle
  /// Please stand directly at the bus stop sign to help improve our GPS accuracy.
  case stopDetailEditCluesetCaptureLocationInfoMessage
  /// Okay, I’m at the sign
  case stopDetailEditCluesetCaptureLocationCaptureButtonTitle
  /// Skip this step
  case stopDetailEditCluesetCaptureLocationSkipButtonTitle
  /// Locating…
  case stopDetailEditCluesetCaptureLocationCardLoadingTitle
  /// <bold>Got it!</bold> Next, we’ll ask you about physical landmarks, working outwards from the bus stop sign.
  case stopDetailEditCluesetCaptureLocationCardThanksMessage
  /// Next Clue
  case stopDetailEditCluesetNextClueLong
  /// Next
  case stopDetailEditCluesetNextClueShort
  /// Skip Clue
  case stopDetailEditCluesetSkipClueLong
  /// Skip
  case stopDetailEditCluesetSkipClueShort
  /// Left of sign far clue
  case stopDetailEditCluesetAccessibilityLeftFarTitle
  /// Left of sign near clue
  case stopDetailEditCluesetAccessibilityLeftNearTitle
  /// Bus stop sign clue
  case stopDetailEditCluesetAccessibilityBusStopSignTitle
  /// Right of sign near clue
  case stopDetailEditCluesetAccessibilityRightNearTitle
  /// Right of sign far clue
  case stopDetailEditCluesetAccessibilityRightFarTitle
  /// Acquiring your current location. This may take a few seconds.
  case stopDetailEditCluesetAccessibilityLocatingTitle
  /// Account Required
  case stopDetailAccountRequiredTitle
  /// In order to add or edit clues, you must be signed in to a BlindWays account.
  case stopDetailEditCluesAccountRequiredMessage
  /// In order to save stops, you must be signed in to a BlindWays account.
  case stopDetailSaveStopsAccountRequiredMessage
  /// Join
  case stopDetailAccountRequiredSignUpButtonTitle
  /// Sign In
  case stopDetailAccountRequiredSignInButtonTitle
  /// You must be signed in to a valid user account in order to save stops.
  case stopsEmptyStateSavedAccountRequired
  /// Review
  case stopDetailEditCluesetReviewTitle
  /// From left to right, the clues are:
  case stopDetailEditCluesetReviewHeader
  /// Help
  case stopDetailEditCluesetReviewHelpAccessibilityLabel
  /// Any other features to help a blind person positively identify the stop?
  case stopDetailEditCluesetReviewNotesPrompt
  /// Enter optional notes
  case stopDetailEditCluesetReviewNotesPlaceholder
  /// %d character
  case stopDetailEditCluesetReviewNotesCharactersFormatSingular(Int)
  /// %d characters
  case stopDetailEditCluesetReviewNotesCharactersFormatPlural(Int)
  /// %d characters remaining (maximum of 140 characters)
  case stopDetailEditCluesetReviewNotesAccessibilityCharactersAnnouncement(Int)
  /// Warning, you have left the general vicinity of the bus stop.
  case stopDetailAccessibilityOutOfRangeWarning
  /// Map
  case mapTitle
  /// Results
  case routesSearchBackButtonTitle
  /// Enter a route number.
  case routesSearchPlaceholderTitle
  /// No results for “%@<tightKerning>.”</tightKerning>
  case routesSearchNoResultsMessage(String)
  /// No results for “%@
  case routesSearchNoResultsAccessibilityMessage(String)
  /// Please enter another route number.
  case routesSearchNoResultsSubtitle
  /// %@ to %@
  case routeStopsTitleFormat(String, String)
  /// Outbound
  case routeOutboundLabel
  /// Inbound
  case routeInboundLabel
  /// To %@
  case routeToDestinationFormat(String)
  /// Searching for routes.
  case routesAccessibilitySearchingTitle
  /// Done searching routes, %d results.
  case routesAccessibilityDidSearchTitle(Int)
  /// Guide
  case guideTitle
  /// Hints
  case guideSectionHints
  /// Describe permanent conditions or fixtures that are easy to recognize by touch and with a cane.
  case guideMessageFixtures
  /// Note landmarks that are near the ground within about 30 feet.
  case guideMessageLandmarksImperial
  /// Note landmarks that are near the ground within about 10 meters.
  case guideMessageLandmarksMetric
  /// Consider features that make this bus stop unique or unusual.
  case guideMessageFeatures
  /// Use casual language, like you would describe it out loud to a friend.
  case guideMessageCasual
  /// Instead of visual qualities like color, notice things like size, material, texture, and distance.
  case guideMessageVisual
  /// Example Notes
  case guideSectionExamples
  /// Sign is next to a raised flowerbed. The bus actually stops about 10 feet before, by the bottom of the stone steps.
  case guideExampleGood
  /// Crowded stop, near a blue dumpster across the street from the clock tower.
  case guideExampleBad
  /// Example of a helpful note: %@
  case guideExampleAccessibilityPrefixHelpful(String)
  /// Example of an unhelpful note: %@
  case guideExampleAccessibilityPrefixUnhelpful(String)
}
// swiftlint:enable type_body_length

extension UIStrings: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .emptyStateGenericError:
        return UIStrings.tr(key: "empty.state.generic.error")
      case .emptyStateGenericNoData:
        return UIStrings.tr(key: "empty.state.generic.no.data")
      case .emptyStateGenericNoInternet:
        return UIStrings.tr(key: "empty.state.generic.no.internet")
      case .errorUnknownMessage:
        return UIStrings.tr(key: "error.unknown.message")
      case .commonCancel:
        return UIStrings.tr(key: "common.cancel")
      case .commonClose:
        return UIStrings.tr(key: "common.close")
      case .commonDone:
        return UIStrings.tr(key: "common.done")
      case .commonOk:
        return UIStrings.tr(key: "common.ok")
      case .commonOn:
        return UIStrings.tr(key: "common.on")
      case .commonOff:
        return UIStrings.tr(key: "common.off")
      case .commonSubmit:
        return UIStrings.tr(key: "common.submit")
      case .commonSuccess:
        return UIStrings.tr(key: "common.success")
      case .commonProblem:
        return UIStrings.tr(key: "common.problem")
      case .commonTryAgain:
        return UIStrings.tr(key: "common.try.again")
      case .commonRefresh:
        return UIStrings.tr(key: "common.refresh")
      case .commonContinue:
        return UIStrings.tr(key: "common.continue")
      case .commonNow:
        return UIStrings.tr(key: "common.now")
      case .commonTruncation(let p0):
        return UIStrings.tr(key: "common.truncation", p0)
      case .commonDismiss:
        return UIStrings.tr(key: "common.dismiss")
      case .commonConcatenateTwoSentences(let p0, let p1):
        return UIStrings.tr(key: "common.concatenate.two.sentences", p0, p1)
      case .errorEmailAlreadyInUse:
        return UIStrings.tr(key: "error.email.already.in.use")
      case .errorInvalidCredentials:
        return UIStrings.tr(key: "error.invalid.credentials")
      case .onboardingMainMessageWelcomeScreen:
        return UIStrings.tr(key: "onboarding.mainMessage.welcomeScreen")
      case .onboardingMainMessageLocationScreen:
        return UIStrings.tr(key: "onboarding.mainMessage.locationScreen")
      case .onboardingMainMessageNotificationsScreen:
        return UIStrings.tr(key: "onboarding.mainMessage.notificationsScreen")
      case .onboardingMainMessageJoinScreen:
        return UIStrings.tr(key: "onboarding.mainMessage.joinScreen")
      case .onboardingMainActionTitleWelcomeScreen:
        return UIStrings.tr(key: "onboarding.mainActionTitle.welcomeScreen")
      case .onboardingMainActionTitleLocationScreen:
        return UIStrings.tr(key: "onboarding.mainActionTitle.locationScreen")
      case .onboardingMainActionTitleNotificationsScreen:
        return UIStrings.tr(key: "onboarding.mainActionTitle.notificationsScreen")
      case .onboardingMainActionTitleJoinScreen:
        return UIStrings.tr(key: "onboarding.mainActionTitle.joinScreen")
      case .onboardingSecondaryActionTitleSkip:
        return UIStrings.tr(key: "onboarding.secondaryActionTitle.skip")
      case .onboardingSecondaryActionTitleJoinScreen:
        return UIStrings.tr(key: "onboarding.secondaryActionTitle.joinScreen")
      case .onboardingTertiaryActionTitleJoinScreen:
        return UIStrings.tr(key: "onboarding.tertiaryActionTitle.joinScreen")
      case .signupTitle:
        return UIStrings.tr(key: "signup.title")
      case .signupEmailTitle:
        return UIStrings.tr(key: "signup.email.title")
      case .signupEmailPlaceholder:
        return UIStrings.tr(key: "signup.email.placeholder")
      case .signupPasswordTitle:
        return UIStrings.tr(key: "signup.password.title")
      case .signupPasswordPlaceholder:
        return UIStrings.tr(key: "signup.password.placeholder")
      case .signupAlreadyHaveAccountTitle:
        return UIStrings.tr(key: "signup.already.have.account.title")
      case .signupAccessibilitySavingMessage:
        return UIStrings.tr(key: "signup.accessibility.saving.message")
      case .signinTitle:
        return UIStrings.tr(key: "signin.title")
      case .signinHeader:
        return UIStrings.tr(key: "signin.header")
      case .signinEmailTitle:
        return UIStrings.tr(key: "signin.email.title")
      case .signinEmailPlaceholder:
        return UIStrings.tr(key: "signin.email.placeholder")
      case .signinPasswordTitle:
        return UIStrings.tr(key: "signin.password.title")
      case .signinPasswordPlaceholder:
        return UIStrings.tr(key: "signin.password.placeholder")
      case .signinForgotPasswordButtonTitle:
        return UIStrings.tr(key: "signin.forgot.password.button.title")
      case .signinAccessibilitySavingMessage:
        return UIStrings.tr(key: "signin.accessibility.saving.message")
      case .signinForgotPasswordAlertTitle:
        return UIStrings.tr(key: "signin.forgot.password.alert.title")
      case .signinForgotPasswordAlertMessage:
        return UIStrings.tr(key: "signin.forgot.password.alert.message")
      case .signinForgotPasswordAlertSuccessMessage(let p0):
        return UIStrings.tr(key: "signin.forgot.password.alert.success.message", p0)
      case .settingsTitle:
        return UIStrings.tr(key: "settings.title")
      case .settingsSectionTitleAccount:
        return UIStrings.tr(key: "settings.section.title.account")
      case .settingsSignIn:
        return UIStrings.tr(key: "settings.sign.in")
      case .settingsSignUp:
        return UIStrings.tr(key: "settings.sign.up")
      case .settingsEmail:
        return UIStrings.tr(key: "settings.email")
      case .settingsPassword:
        return UIStrings.tr(key: "settings.password")
      case .settingsChangePassword:
        return UIStrings.tr(key: "settings.change.password")
      case .settingsAgency:
        return UIStrings.tr(key: "settings.agency")
      case .settingsLocationServices:
        return UIStrings.tr(key: "settings.location.services")
      case .settingsNotifications:
        return UIStrings.tr(key: "settings.notifications")
      case .settingsNavigationHelper:
        return UIStrings.tr(key: "settings.navigation.helper")
      case .settingsSectionTitleAbout:
        return UIStrings.tr(key: "settings.section.title.about")
      case .settingsAbout:
        return UIStrings.tr(key: "settings.about")
      case .settingsShare:
        return UIStrings.tr(key: "settings.share")
      case .settingsRate:
        return UIStrings.tr(key: "settings.rate")
      case .settingsFeedback:
        return UIStrings.tr(key: "settings.feedback")
      case .settingsSignOut:
        return UIStrings.tr(key: "settings.sign.out")
      case .settingsDeleteAccount:
        return UIStrings.tr(key: "settings.delete.account")
      case .settingsSignOutAlertMessage:
        return UIStrings.tr(key: "settings.sign.out.alert.message")
      case .settingsShareMessage:
        return UIStrings.tr(key: "settings.share.message")
      case .settingsNavigationHelperNotSet:
        return UIStrings.tr(key: "settings.navigation.helper.not.set")
      case .settingsNavigationHelperHint:
        return UIStrings.tr(key: "settings.navigation.helper.hint")
      case .settingsNavigationHelperSelectMessage:
        return UIStrings.tr(key: "settings.navigation.helper.select.message")
      case .settingsChangeEmailAlertTitle:
        return UIStrings.tr(key: "settings.change.email.alert.title")
      case .settingsChangeEmailAlertMessage:
        return UIStrings.tr(key: "settings.change.email.alert.message")
      case .settingsChangeEmailAlertPlaceholder:
        return UIStrings.tr(key: "settings.change.email.alert.placeholder")
      case .settingsChangeEmailAlertSuccessTitle:
        return UIStrings.tr(key: "settings.change.email.alert.success.title")
      case .settingsChangeEmailAlertSuccessMessage(let p0):
        return UIStrings.tr(key: "settings.change.email.alert.success.message", p0)
      case .settingsChangePasswordAlertTitle:
        return UIStrings.tr(key: "settings.change.password.alert.title")
      case .settingsChangePasswordAlertMessage:
        return UIStrings.tr(key: "settings.change.password.alert.message")
      case .settingsChangePasswordOldFieldName:
        return UIStrings.tr(key: "settings.change.password.old.field.name")
      case .settingsChangePasswordNewFieldName:
        return UIStrings.tr(key: "settings.change.password.new.field.name")
      case .settingsChangePasswordAlertOldPlaceholder:
        return UIStrings.tr(key: "settings.change.password.alert.old.placeholder")
      case .settingsChangePasswordAlertNewPlaceholder:
        return UIStrings.tr(key: "settings.change.password.alert.new.placeholder")
      case .settingsChangePasswordAlertSuccessTitle:
        return UIStrings.tr(key: "settings.change.password.alert.success.title")
      case .settingsChangePasswordAlertSuccessMessage:
        return UIStrings.tr(key: "settings.change.password.alert.success.message")
      case .settingsChangePasswordAlertFailureTitle:
        return UIStrings.tr(key: "settings.change.password.alert.failure.title")
      case .settingsChangePasswordAlertFailureMessage:
        return UIStrings.tr(key: "settings.change.password.alert.failure.message")
      case .settingsDeleteAccountAlertButtonTitle:
        return UIStrings.tr(key: "settings.delete.account.alert.button.title")
      case .settingsDeleteAccountAlertMessage:
        return UIStrings.tr(key: "settings.delete.account.alert.message")
      case .settingsAboutTitle:
        return UIStrings.tr(key: "settings.about.title")
      case .settingsAboutPerkins:
        return UIStrings.tr(key: "settings.about.perkins")
      case .settingsAboutLearnMore:
        return UIStrings.tr(key: "settings.about.learn.more")
      case .settingsAboutAcknowledgements:
        return UIStrings.tr(key: "settings.about.acknowledgements")
      case .settingsAboutTerms:
        return UIStrings.tr(key: "settings.about.terms")
      case .settingsAboutCopyrightFooter:
        return UIStrings.tr(key: "settings.about.copyright.footer")
      case .agenciesTitle:
        return UIStrings.tr(key: "agencies.title")
      case .agenciesOtherServiceAreas:
        return UIStrings.tr(key: "agencies.otherServiceAreas")
      case .agenciesDescriptionChanged:
        return UIStrings.tr(key: "agencies.description.changed")
      case .agenciesDescriptionNearby:
        return UIStrings.tr(key: "agencies.description.nearby")
      case .agenciesDescriptionSupported:
        return UIStrings.tr(key: "agencies.description.supported")
      case .agenciesEmptyStateNoResults:
        return UIStrings.tr(key: "agencies.empty.state.no.results")
      case .stopsTitle:
        return UIStrings.tr(key: "stops.title")
      case .stopsBackButtonTitleNearby:
        return UIStrings.tr(key: "stops.back.button.title.nearby")
      case .stopsBackButtonTitleSaved:
        return UIStrings.tr(key: "stops.back.button.title.saved")
      case .stopsRefreshButtonTitle:
        return UIStrings.tr(key: "stops.refresh.button.title")
      case .stopsAccessibilityRefreshingTitle(let p0):
        return UIStrings.tr(key: "stops.accessibility.refreshing.title", p0)
      case .stopsAccessibilityDidRefreshTitle(let p0):
        return UIStrings.tr(key: "stops.accessibility.did.refresh.title", p0)
      case .stopsNearbyTitle:
        return UIStrings.tr(key: "stops.nearby.title")
      case .stopsSavedTitle:
        return UIStrings.tr(key: "stops.saved.title")
      case .stopsCellRouteTitle:
        return UIStrings.tr(key: "stops.cell.route.title")
      case .stopsCellRoutesTitle:
        return UIStrings.tr(key: "stops.cell.routes.title")
      case .stopsCellRoutesTitleFormat(let p0):
        return UIStrings.tr(key: "stops.cell.routes.title.format", p0)
      case .stopsCellNeedsMoreCluesTitle:
        return UIStrings.tr(key: "stops.cell.needs.more.clues.title")
      case .stopsEmptyStateNoResults:
        return UIStrings.tr(key: "stops.empty.state.no.results")
      case .stopsEmptyStateNoNearby:
        return UIStrings.tr(key: "stops.empty.state.no.nearby")
      case .stopsEmptyStateNoSaved:
        return UIStrings.tr(key: "stops.empty.state.no.saved")
      case .stopsEmptyStateLocationServicesDisabled:
        return UIStrings.tr(key: "stops.empty.state.location.services.disabled")
      case .stopsEmptyStateLocationSettings:
        return UIStrings.tr(key: "stops.empty.state.location.settings")
      case .stopsEmptyStateEnableLocation:
        return UIStrings.tr(key: "stops.empty.state.enable.location")
      case .stopsArrivalsTitle:
        return UIStrings.tr(key: "stops.arrivals.title")
      case .stopsArrivalsMinutesLabelFormat(let p0):
        return UIStrings.tr(key: "stops.arrivals.minutes.label.format", p0)
      case .stopsArrivalsRouteLabelFormat(let p0):
        return UIStrings.tr(key: "stops.arrivals.route.label.format", p0)
      case .stopsArrivalsEmptyStateNoData:
        return UIStrings.tr(key: "stops.arrivals.empty.state.no.data")
      case .stopsArrivalsAccessibilityRefreshingTitle:
        return UIStrings.tr(key: "stops.arrivals.accessibility.refreshing.title")
      case .stopsArrivalsAccessibilityDidRefreshTitle(let p0):
        return UIStrings.tr(key: "stops.arrivals.accessibility.did.refresh.title", p0)
      case .stopsArrivalsNextRefreshingSingularSecondsFormat(let p0):
        return UIStrings.tr(key: "stops.arrivals.next.refreshing.singular.seconds.format", p0)
      case .stopsArrivalsNextRefreshingPluralSecondsFormat(let p0):
        return UIStrings.tr(key: "stops.arrivals.next.refreshing.plural.seconds.format", p0)
      case .stopDetailAccessibilityLoadingTitle:
        return UIStrings.tr(key: "stop.detail.accessibility.loading.title")
      case .stopDetailArrivalsLoadingTitle:
        return UIStrings.tr(key: "stop.detail.arrivals.loading.title")
      case .stopDetailArrivalsLoadingSubtitle:
        return UIStrings.tr(key: "stop.detail.arrivals.loading.subtitle")
      case .stopDetailArrivalsNoResultsTitle:
        return UIStrings.tr(key: "stop.detail.arrivals.no.results.title")
      case .stopDetailArrivalsNoResultsSubtitle:
        return UIStrings.tr(key: "stop.detail.arrivals.no.results.subtitle")
      case .stopDetailArrivalsTitle(let p0):
        return UIStrings.tr(key: "stop.detail.arrivals.title", p0)
      case .stopDetailArrivalsTitleNow:
        return UIStrings.tr(key: "stop.detail.arrivals.title.now")
      case .stopDetailArrivalsSubtitle(let p0, let p1):
        return UIStrings.tr(key: "stop.detail.arrivals.subtitle", p0, p1)
      case .stopDetailLocationFetchingTitle:
        return UIStrings.tr(key: "stop.detail.location.fetching.title")
      case .stopDetailLocationFetchingSubtitle:
        return UIStrings.tr(key: "stop.detail.location.fetching.subtitle")
      case .stopDetailLocationAccuracyBad:
        return UIStrings.tr(key: "stop.detail.location.accuracy.bad")
      case .stopDetailLocationAccuracyFair:
        return UIStrings.tr(key: "stop.detail.location.accuracy.fair")
      case .stopDetailLocationAccuracyGood:
        return UIStrings.tr(key: "stop.detail.location.accuracy.good")
      case .stopDetailLocationWithinFt(let p0):
        return UIStrings.tr(key: "stop.detail.location.within.ft", p0)
      case .stopDetailLocationWithinM(let p0):
        return UIStrings.tr(key: "stop.detail.location.within.m", p0)
      case .stopDetailLocationMiAway(let p0):
        return UIStrings.tr(key: "stop.detail.location.mi away", p0)
      case .stopDetailLocationKmAway(let p0):
        return UIStrings.tr(key: "stop.detail.location.km away", p0)
      case .stopDetailLocationNavigateSubtitle:
        return UIStrings.tr(key: "stop.detail.location.navigate.subtitle")
      case .stopDetailLocationShowMapSubtitle:
        return UIStrings.tr(key: "stop.detail.location.show.map.subtitle")
      case .stopDetailLocationNavigatePromptTitle:
        return UIStrings.tr(key: "stop.detail.location.navigate.prompt.title")
      case .stopDetailLocationNavigatePromptSubtitle(let p0):
        return UIStrings.tr(key: "stop.detail.location.navigate.prompt.subtitle", p0)
      case .stopDetailLocationNavigateAppNameApple:
        return UIStrings.tr(key: "stop.detail.location.navigate.app.name.apple")
      case .stopDetailLocationNavigateAppNameBlindsquare:
        return UIStrings.tr(key: "stop.detail.location.navigate.app.name.blindsquare")
      case .stopDetailLocationNavigateAppNameGoogle:
        return UIStrings.tr(key: "stop.detail.location.navigate.app.name.google")
      case .stopDetailLocationDisabledTitle:
        return UIStrings.tr(key: "stop.detail.location.disabled.title")
      case .stopDetailLocationDisabledSubtitle:
        return UIStrings.tr(key: "stop.detail.location.disabled.subtitle")
      case .stopDetailLocationDisabledEnableSubtitle:
        return UIStrings.tr(key: "stop.detail.location.disabled.enable.subtitle")
      case .stopDetailAccessibilityStopSavedTitle:
        return UIStrings.tr(key: "stop.detail.accessibility.stop.saved.title")
      case .stopDetailAccessibilityStopSavedHint:
        return UIStrings.tr(key: "stop.detail.accessibility.stop.saved.hint")
      case .stopDetailAccessibilityStopSaveTitle:
        return UIStrings.tr(key: "stop.detail.accessibility.stop.save.title")
      case .stopDetailAccessibilityStopSaveHint:
        return UIStrings.tr(key: "stop.detail.accessibility.stop.save.hint")
      case .stopDetailAccessibilityArrivalsAction:
        return UIStrings.tr(key: "stop.detail.accessibility.arrivals.action")
      case .stopDetailAccessibilityLocationIconLabel:
        return UIStrings.tr(key: "stop.detail.accessibility.location.icon.label")
      case .stopDetailCluesetPrefixBefore:
        return UIStrings.tr(key: "stop.detail.clueset.prefix.before")
      case .stopDetailCluesetPrefixCloser:
        return UIStrings.tr(key: "stop.detail.clueset.prefix.closer")
      case .stopDetailCluesetPrefixBusStopSign:
        return UIStrings.tr(key: "stop.detail.clueset.prefix.bus.stop.sign")
      case .stopDetailCluesetPrefixBeyond:
        return UIStrings.tr(key: "stop.detail.clueset.prefix.beyond")
      case .stopDetailCluesetPrefixFurtherPast:
        return UIStrings.tr(key: "stop.detail.clueset.prefix.further.past")
      case .stopDetailCluesetReviewPrefixFarLeft:
        return UIStrings.tr(key: "stop.detail.clueset.review.prefix.far.left")
      case .stopDetailCluesetReviewPrefixNearLeft:
        return UIStrings.tr(key: "stop.detail.clueset.review.prefix.near.left")
      case .stopDetailCluesetReviewPrefixBusStop:
        return UIStrings.tr(key: "stop.detail.clueset.review.prefix.bus.stop")
      case .stopDetailCluesetReviewPrefixNearRight:
        return UIStrings.tr(key: "stop.detail.clueset.review.prefix.near.right")
      case .stopDetailCluesetReviewPrefixFarRight:
        return UIStrings.tr(key: "stop.detail.clueset.review.prefix.far.right")
      case .stopDetailCluesetAccessibilityEmptyBefore:
        return UIStrings.tr(key: "stop.detail.clueset.accessibility.empty.before")
      case .stopDetailCluesetAccessibilityEmptyCloser:
        return UIStrings.tr(key: "stop.detail.clueset.accessibility.empty.closer")
      case .stopDetailCluesetAccessibilityEmptyBusStopSign:
        return UIStrings.tr(key: "stop.detail.clueset.accessibility.empty.bus.stop.sign")
      case .stopDetailCluesetAccessibilityEmptyBeyond:
        return UIStrings.tr(key: "stop.detail.clueset.accessibility.empty.beyond")
      case .stopDetailCluesetAccessibilityEmptyFurtherPast:
        return UIStrings.tr(key: "stop.detail.clueset.accessibility.empty.further.past")
      case .stopDetailCluesetAccessibilityEmptyReviewFarLeft:
        return UIStrings.tr(key: "stop.detail.clueset.accessibility.empty.review.far.left")
      case .stopDetailCluesetAccessibilityEmptyReviewNearLeft:
        return UIStrings.tr(key: "stop.detail.clueset.accessibility.empty.review.near.left")
      case .stopDetailCluesetAccessibilityEmptyReviewBusStop:
        return UIStrings.tr(key: "stop.detail.clueset.accessibility.empty.review.bus.stop")
      case .stopDetailCluesetAccessibilityEmptyReviewNearRight:
        return UIStrings.tr(key: "stop.detail.clueset.accessibility.empty.review.near.right")
      case .stopDetailCluesetAccessibilityEmptyReviewFarRight:
        return UIStrings.tr(key: "stop.detail.clueset.accessibility.empty.review.far.right")
      case .stopDetailCluesetPrefixBusStopEmpty:
        return UIStrings.tr(key: "stop.detail.clueset.prefix.bus.stop.empty")
      case .stopDetailCluesetReviewEmptySuffix:
        return UIStrings.tr(key: "stop.detail.clueset.review.empty.suffix")
      case .stopDetailAddClueButtonTitle:
        return UIStrings.tr(key: "stop.detail.add.clue.button.title")
      case .stopDetailEditClueButtonTitle:
        return UIStrings.tr(key: "stop.detail.edit.clue.button.title")
      case .stopDetailClueBusStopSignTitle:
        return UIStrings.tr(key: "stop.detail.clue.bus.stop.sign.title")
      case .stopDetailAccessibilityAddClueHint:
        return UIStrings.tr(key: "stop.detail.accessibility.add.clue.hint")
      case .stopDetailClueActionsConfirmTitle:
        return UIStrings.tr(key: "stop.detail.clue.actions.confirm.title")
      case .stopDetailClueActionsRateHelpfulTitle:
        return UIStrings.tr(key: "stop.detail.clue.actions.rate.helpful.title")
      case .stopDetailClueActionsReportProblemTitle:
        return UIStrings.tr(key: "stop.detail.clue.actions.report.problem.title")
      case .stopDetailClueActionsEditClueTitle:
        return UIStrings.tr(key: "stop.detail.clue.actions.edit.clue.title")
      case .stopDetailClueActionsDeleteClueTitle:
        return UIStrings.tr(key: "stop.detail.clue.actions.delete.clue.title")
      case .stopDetailClueActionsThanksTitle:
        return UIStrings.tr(key: "stop.detail.clue.actions.thanks.title")
      case .stopDetailClueActionsConfirmThanksMessage:
        return UIStrings.tr(key: "stop.detail.clue.actions.confirm.thanks.message")
      case .stopDetailClueActionsReportProblemThanksMessage:
        return UIStrings.tr(key: "stop.detail.clue.actions.report.problem.thanks.message")
      case .stopDetailCluesetEmptyStateNoCluesMessage:
        return UIStrings.tr(key: "stop.detail.clueset.empty.state.no.clues.message")
      case .stopDetailCluesetEmptyStateNoCluesActionTitle:
        return UIStrings.tr(key: "stop.detail.clueset.empty.state.no.clues.action.title")
      case .stopDetailCluesetHeaderChangeButtonTitle:
        return UIStrings.tr(key: "stop.detail.clueset.header.change.button.title")
      case .stopDetailCluesetHeaderAccessibilityChangeButtonHint:
        return UIStrings.tr(key: "stop.detail.clueset.header.accessibility.change.button.hint")
      case .stopDetailCluesetHeaderApproachingLeft:
        return UIStrings.tr(key: "stop.detail.clueset.header.approaching.left")
      case .stopDetailCluesetHeaderApproachingRight:
        return UIStrings.tr(key: "stop.detail.clueset.header.approaching.right")
      case .stopDetailEditCluesetClueHeaderTitleFarLeft:
        return UIStrings.tr(key: "stop.detail.edit.clueset.clue.header.title.far.left")
      case .stopDetailEditCluesetClueHeaderTitleNearLeft:
        return UIStrings.tr(key: "stop.detail.edit.clueset.clue.header.title.near.left")
      case .stopDetailEditCluesetClueHeaderTitleBusStop:
        return UIStrings.tr(key: "stop.detail.edit.clueset.clue.header.title.bus.stop")
      case .stopDetailEditCluesetClueHeaderTitleNearRight:
        return UIStrings.tr(key: "stop.detail.edit.clueset.clue.header.title.near.right")
      case .stopDetailEditCluesetClueHeaderTitleFarRight:
        return UIStrings.tr(key: "stop.detail.edit.clueset.clue.header.title.far.right")
      case .stopDetailEditCluesetTitleAdd:
        return UIStrings.tr(key: "stop.detail.edit.clueset.title.add")
      case .stopDetailEditCluesetTitleEdit:
        return UIStrings.tr(key: "stop.detail.edit.clueset.title.edit")
      case .stopDetailEditCluesetSectionHeaderTipButtontitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.section.header.tip.buttontitle")
      case .stopDetailEditCluesetSectionHeaderClueTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.section.header.clue.title")
      case .stopDetailEditCluesetSectionHeaderClueSignTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.section.header.clue.sign.title")
      case .stopDetailEditCluesetSectionHeaderDetailLeftFar:
        return UIStrings.tr(key: "stop.detail.edit.clueset.section.header.detail.left.far")
      case .stopDetailEditCluesetSectionHeaderDetailLeftNear:
        return UIStrings.tr(key: "stop.detail.edit.clueset.section.header.detail.left.near")
      case .stopDetailEditCluesetSectionHeaderDetailBusStopSign:
        return UIStrings.tr(key: "stop.detail.edit.clueset.section.header.detail.bus.stop.sign")
      case .stopDetailEditCluesetSectionHeaderDetailRightNear:
        return UIStrings.tr(key: "stop.detail.edit.clueset.section.header.detail.right.near")
      case .stopDetailEditCluesetSectionHeaderDetailRightFar:
        return UIStrings.tr(key: "stop.detail.edit.clueset.section.header.detail.right.far")
      case .stopDetailEditCluesetFieldOnGrassTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.field.on.grass.title")
      case .stopDetailEditCluesetFieldAlongCurbTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.field.along.curb.title")
      case .stopDetailEditCluesetFieldAwayFromCurbImperialTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.field.away.from.curb.imperial.title")
      case .stopDetailEditCluesetFieldAwayFromCurbMetricTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.field.away.from.curb.metric.title")
      case .stopDetailEditCluesetFieldBusSignHintTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.field.bus.sign.hint.title")
      case .stopDetailCluesetPlacementInitialFormatBusStopSign(let p0, let p1):
        return UIStrings.tr(key: "stop.detail.clueset.placement.initial.format.bus.stop.sign", p0, p1)
      case .stopDetailCluesetPlacementInitialFormatGeneric(let p0, let p1):
        return UIStrings.tr(key: "stop.detail.clueset.placement.initial.format.generic", p0, p1)
      case .stopDetailCluesetPlacementSubsequentFormat(let p0):
        return UIStrings.tr(key: "stop.detail.clueset.placement.subsequent.format", p0)
      case .stopDetailEditCluesetSectionHeaderOtherFormat(let p0):
        return UIStrings.tr(key: "stop.detail.edit.clueset.section.header.other.format", p0)
      case .stopDetailEditCluesetSectionHeaderDescriptionFormat(let p0):
        return UIStrings.tr(key: "stop.detail.edit.clueset.section.header.description.format", p0)
      case .stopDetailEditCluesetSectionHeaderPlacementTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.section.header.placement.title")
      case .stopDetailEditCluesetThanksTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.thanks.title")
      case .stopDetailEditCluesetThanksMessage:
        return UIStrings.tr(key: "stop.detail.edit.clueset.thanks.message")
      case .stopDetailEditCluesetOtherAlertTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.other.alert.title")
      case .stopDetailEditCluesetOtherAlertMessage:
        return UIStrings.tr(key: "stop.detail.edit.clueset.other.alert.message")
      case .stopDetailEditCluesetOtherAlertPlaceholder:
        return UIStrings.tr(key: "stop.detail.edit.clueset.other.alert.placeholder")
      case .stopDetailEditCluesetSaveErrorMessage:
        return UIStrings.tr(key: "stop.detail.edit.clueset.save.error.message")
      case .stopDetailDeleteClueSaveErrorMessage:
        return UIStrings.tr(key: "stop.detail.delete.clue.save.error.message")
      case .stopDetailDeleteClueAccessibilitySuccessMessage:
        return UIStrings.tr(key: "stop.detail.delete.clue.accessibility.success.message")
      case .stopDetailEditCluesetUnsavedChangesDiscardTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.unsaved.changes.discard.title")
      case .stopDetailEditCluesetUnsavedChangesSaveTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.unsaved.changes.save.title")
      case .stopDetailEditCluesetCaptureLocationInfoMessage:
        return UIStrings.tr(key: "stop.detail.edit.clueset.capture.location.info.message")
      case .stopDetailEditCluesetCaptureLocationCaptureButtonTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.capture.location.capture.button.title")
      case .stopDetailEditCluesetCaptureLocationSkipButtonTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.capture.location.skip.button.title")
      case .stopDetailEditCluesetCaptureLocationCardLoadingTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.capture.location.card.loading.title")
      case .stopDetailEditCluesetCaptureLocationCardThanksMessage:
        return UIStrings.tr(key: "stop.detail.edit.clueset.capture.location.card.thanks.message")
      case .stopDetailEditCluesetNextClueLong:
        return UIStrings.tr(key: "stop.detail.edit.clueset.next.clue.long")
      case .stopDetailEditCluesetNextClueShort:
        return UIStrings.tr(key: "stop.detail.edit.clueset.next.clue.short")
      case .stopDetailEditCluesetSkipClueLong:
        return UIStrings.tr(key: "stop.detail.edit.clueset.skip.clue.long")
      case .stopDetailEditCluesetSkipClueShort:
        return UIStrings.tr(key: "stop.detail.edit.clueset.skip.clue.short")
      case .stopDetailEditCluesetAccessibilityLeftFarTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.accessibility.left.far.title")
      case .stopDetailEditCluesetAccessibilityLeftNearTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.accessibility.left.near.title")
      case .stopDetailEditCluesetAccessibilityBusStopSignTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.accessibility.bus.stop.sign.title")
      case .stopDetailEditCluesetAccessibilityRightNearTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.accessibility.right.near.title")
      case .stopDetailEditCluesetAccessibilityRightFarTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.accessibility.right.far.title")
      case .stopDetailEditCluesetAccessibilityLocatingTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.accessibility.locating.title")
      case .stopDetailAccountRequiredTitle:
        return UIStrings.tr(key: "stop.detail.account.required.title")
      case .stopDetailEditCluesAccountRequiredMessage:
        return UIStrings.tr(key: "stop.detail.edit.clues.account.required.message")
      case .stopDetailSaveStopsAccountRequiredMessage:
        return UIStrings.tr(key: "stop.detail.save.stops.account.required.message")
      case .stopDetailAccountRequiredSignUpButtonTitle:
        return UIStrings.tr(key: "stop.detail.account.required.sign.up.button.title")
      case .stopDetailAccountRequiredSignInButtonTitle:
        return UIStrings.tr(key: "stop.detail.account.required.sign.in.button.title")
      case .stopsEmptyStateSavedAccountRequired:
        return UIStrings.tr(key: "stops.empty.state.saved.account.required")
      case .stopDetailEditCluesetReviewTitle:
        return UIStrings.tr(key: "stop.detail.edit.clueset.review.title")
      case .stopDetailEditCluesetReviewHeader:
        return UIStrings.tr(key: "stop.detail.edit.clueset.review.header")
      case .stopDetailEditCluesetReviewHelpAccessibilityLabel:
        return UIStrings.tr(key: "stop.detail.edit.clueset.review.help.accessibility.label")
      case .stopDetailEditCluesetReviewNotesPrompt:
        return UIStrings.tr(key: "stop.detail.edit.clueset.review.notes.prompt")
      case .stopDetailEditCluesetReviewNotesPlaceholder:
        return UIStrings.tr(key: "stop.detail.edit.clueset.review.notes.placeholder")
      case .stopDetailEditCluesetReviewNotesCharactersFormatSingular(let p0):
        return UIStrings.tr(key: "stop.detail.edit.clueset.review.notes.characters.format.singular", p0)
      case .stopDetailEditCluesetReviewNotesCharactersFormatPlural(let p0):
        return UIStrings.tr(key: "stop.detail.edit.clueset.review.notes.characters.format.plural", p0)
      case .stopDetailEditCluesetReviewNotesAccessibilityCharactersAnnouncement(let p0):
        return UIStrings.tr(key: "stop.detail.edit.clueset.review.notes.accessibility.characters.announcement", p0)
      case .stopDetailAccessibilityOutOfRangeWarning:
        return UIStrings.tr(key: "stop.detail.accessibility.out.of.range.warning")
      case .mapTitle:
        return UIStrings.tr(key: "map.title")
      case .routesSearchBackButtonTitle:
        return UIStrings.tr(key: "routes.search.back.button.title")
      case .routesSearchPlaceholderTitle:
        return UIStrings.tr(key: "routes.search.placeholder.title")
      case .routesSearchNoResultsMessage(let p0):
        return UIStrings.tr(key: "routes.search.no.results.message", p0)
      case .routesSearchNoResultsAccessibilityMessage(let p0):
        return UIStrings.tr(key: "routes.search.no.results.accessibility.message", p0)
      case .routesSearchNoResultsSubtitle:
        return UIStrings.tr(key: "routes.search.no.results.subtitle")
      case .routeStopsTitleFormat(let p0, let p1):
        return UIStrings.tr(key: "route.stops.title.format", p0, p1)
      case .routeOutboundLabel:
        return UIStrings.tr(key: "route.outbound.label")
      case .routeInboundLabel:
        return UIStrings.tr(key: "route.inbound.label")
      case .routeToDestinationFormat(let p0):
        return UIStrings.tr(key: "route.to.destination.format", p0)
      case .routesAccessibilitySearchingTitle:
        return UIStrings.tr(key: "routes.accessibility.searching.title")
      case .routesAccessibilityDidSearchTitle(let p0):
        return UIStrings.tr(key: "routes.accessibility.did.search.title", p0)
      case .guideTitle:
        return UIStrings.tr(key: "guide.title")
      case .guideSectionHints:
        return UIStrings.tr(key: "guide.section.hints")
      case .guideMessageFixtures:
        return UIStrings.tr(key: "guide.message.fixtures")
      case .guideMessageLandmarksImperial:
        return UIStrings.tr(key: "guide.message.landmarks.imperial")
      case .guideMessageLandmarksMetric:
        return UIStrings.tr(key: "guide.message.landmarks.metric")
      case .guideMessageFeatures:
        return UIStrings.tr(key: "guide.message.features")
      case .guideMessageCasual:
        return UIStrings.tr(key: "guide.message.casual")
      case .guideMessageVisual:
        return UIStrings.tr(key: "guide.message.visual")
      case .guideSectionExamples:
        return UIStrings.tr(key: "guide.section.examples")
      case .guideExampleGood:
        return UIStrings.tr(key: "guide.example.good")
      case .guideExampleBad:
        return UIStrings.tr(key: "guide.example.bad")
      case .guideExampleAccessibilityPrefixHelpful(let p0):
        return UIStrings.tr(key: "guide.example.accessibility.prefix.helpful", p0)
      case .guideExampleAccessibilityPrefixUnhelpful(let p0):
        return UIStrings.tr(key: "guide.example.accessibility.prefix.unhelpful", p0)
    }
  }

  private static func tr(key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

func tr(key: UIStrings) -> String {
  return key.string
}
