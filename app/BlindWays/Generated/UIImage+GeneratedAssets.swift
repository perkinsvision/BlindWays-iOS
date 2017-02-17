// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

#if os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias Image = UIImage
#elseif os(OSX)
  import AppKit.NSImage
  typealias Image = NSImage
#endif

// swiftlint:disable file_length
// swiftlint:disable type_body_length
enum Asset: String {
  case btnGradientRound = "btn-gradient-round"
  case geoSpinner0 = "geo-spinner0"
  case geoSpinner1 = "geo-spinner1"
  case geoSpinner10 = "geo-spinner10"
  case geoSpinner11 = "geo-spinner11"
  case geoSpinner12 = "geo-spinner12"
  case geoSpinner13 = "geo-spinner13"
  case geoSpinner14 = "geo-spinner14"
  case geoSpinner15 = "geo-spinner15"
  case geoSpinner16 = "geo-spinner16"
  case geoSpinner17 = "geo-spinner17"
  case geoSpinner2 = "geo-spinner2"
  case geoSpinner3 = "geo-spinner3"
  case geoSpinner4 = "geo-spinner4"
  case geoSpinner5 = "geo-spinner5"
  case geoSpinner6 = "geo-spinner6"
  case geoSpinner7 = "geo-spinner7"
  case geoSpinner8 = "geo-spinner8"
  case geoSpinner9 = "geo-spinner9"
  case icnAdd = "icn-add"
  case icnArrival = "icn-arrival"
  case icnArrowL = "icn-arrow-L"
  case icnArrowR = "icn-arrow-R"
  case icnBusSignOn = "icn-bus-sign-on"
  case icnBusSign = "icn-bus-sign"
  case icnBus = "icn-bus"
  case icnChange = "icn-change"
  case icnCheckedAgencyItem = "icn-checked-agencyItem"
  case icnCheckedListitem = "icn-checked-listitem"
  case icnChevronLeft = "icn-chevron-left"
  case icnChevronRight = "icn-chevron-right"
  case icnChevron = "icn-chevron"
  case icnCluenavCheckedOn = "icn-cluenav-checked-on"
  case icnCluenavChecked = "icn-cluenav-checked"
  case icnCluenavDotOn = "icn-cluenav-dot-on"
  case icnCluenavDot = "icn-cluenav-dot"
  case icnExampleDo = "icn-example-do"
  case icnExampleDont = "icn-example-dont"
  case icnLocation = "icn-location"
  case icnMappin = "icn-mappin"
  case icnOptions = "icn-options"
  case icnRefreshSmall = "icn-refresh-small"
  case icnRefresh = "icn-refresh"
  case icnSave = "icn-save"
  case icnSaved = "icn-saved"
  case imgAddclueBus = "img-addclue-bus"
  case imgAddclueBusbody = "img-addclue-busbody"
  case imgAddclueBuswheels = "img-addclue-buswheels"
  case imgAddclueSign = "img-addclue-sign"
  case imgAddclueStreetbackground = "img-addclue-streetbackground"
  case imgEmptyConnection = "img-empty-connection"
  case imgEmptyGeneric = "img-empty-generic"
  case imgEmptyLocation = "img-empty-location"
  case imgEmptyNoclues = "img-empty-noclues"
  case imgEmptyNostops = "img-empty-nostops"
  case imgGeomap = "img-geomap"
  case imgGuideHeader = "img-guide-header"
  case imgMapBg = "img-map-bg"
  case launchScreen = "launch_screen"
  case logoPerkins = "logo-perkins"
  case photoGeo = "photo-geo"
  case photoThanksJeff = "photo-thanks-Jeff"
  case photoThanksJerry = "photo-thanks-Jerry"
  case photoThanksJoann = "photo-thanks-Joann"
  case photoThanksWen = "photo-thanks-Wen"

  var image: Image {
    return Image(asset: self)
  }
}
// swiftlint:enable type_body_length

extension Image {
  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}
