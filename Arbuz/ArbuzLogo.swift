//
//  ArbuzLogo.swift
//  M4Exercise
//
//  Created by Rustem Orazbayev on 5/20/23.
//

import SwiftUI

struct ArbuzLogo: View {
    var body: some View {
        Image("arbuz")
            .resizable()
            .scaledToFit()
            .frame(width: 300)
    }
}

struct ArbuzLogo_Previews: PreviewProvider {
    static var previews: some View {
        ArbuzLogo()
    }
}
