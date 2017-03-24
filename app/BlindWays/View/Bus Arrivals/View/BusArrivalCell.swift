//
//  BusArrivalCell.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/30/16.
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

final class BusArrivalCell: CardCell {

    var viewModel: BusArrivalViewModel? {
        didSet {
            if let viewModel = viewModel {
                routeLabel.text = viewModel.localizedRouteName
                minutesLabel.text = viewModel.localizedMinutesTitle
                destinationLabel.text = viewModel.localizedDestinationTitle
            }
        }
    }

    fileprivate let routeLabel: UILabel = {
        let label = UILabel("routeLabel")
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    fileprivate let destinationLabel: UILabel = {
        let label = UILabel("destinationLabel")
        label.font = UIFont.dynamicSize(style: .headline, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    fileprivate let minutesLabel: UILabel = {
        let label = UILabel("minutesLabel")
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
   }

    override func configureView() {
        super.configureView()

        cardView.addSubview(routeLabel)

        cardView.addSubview(destinationLabel)

        cardView.addSubview(minutesLabel)
    }

    override func configureLayout() {
        super.configureLayout()

        let margin: CGFloat = 13.0
        let spacing: CGFloat = 6.0

        // Separated arguments to reduce compile times
        let routeTopLayout = cardView.topAnchor + margin
        routeLabel.topAnchor == routeTopLayout
        let routeLeadingLayout = cardView.leadingAnchor + margin
        routeLabel.leadingAnchor == routeLeadingLayout
        let routeTrailingLayout = minutesLabel.leadingAnchor - 5
        routeLabel.trailingAnchor == routeTrailingLayout

        minutesLabel.widthAnchor <= 100
        let minutesTopLayout = cardView.topAnchor + margin
        minutesLabel.topAnchor == minutesTopLayout
        let minutesTrailingLayout = cardView.trailingAnchor - margin
        minutesLabel.trailingAnchor == minutesTrailingLayout

        let destinationTopLayout = routeLabel.bottomAnchor + spacing
        destinationLabel.topAnchor == destinationTopLayout
        let destinationHorizontalLayout = cardView.horizontalAnchors + margin
        destinationLabel.horizontalAnchors == destinationHorizontalLayout
        let destinationBottomLayout = cardView.bottomAnchor - margin
        destinationLabel.bottomAnchor == destinationBottomLayout
    }

}
