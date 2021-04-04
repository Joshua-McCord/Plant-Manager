//
//  AccountView.swift
//  PlantManager
//
//  Created by Daniella Ruzinov on 4/3/21.
//  Reference for picker: https://betterprogramming.pub/custom-ios-segmented-control-with-swiftui-473b386d0b51

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            return Color
                    .clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}
struct SizeAwareViewModifier: ViewModifier {

    @Binding private var viewSize: CGSize

    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }

    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self, perform: { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}

struct SegmentedPicker: View {
    private static let ActiveSegmentColor: Color = Color("Accent")
    private static let BackgroundColor: Color = Color("AccentDark")
    private static let TextColor: Color = Color("SliderText")
    private static let TextFont: Font =
        Font.custom("Futura-Medium", size: 20.0)
    
    private static let SegmentCornerRadius: CGFloat = 12
    private static let SegmentXPadding: CGFloat = 8
    private static let SegmentYPadding: CGFloat = 8
    private static let PickerPadding: CGFloat = 4
    
    private static let AnimationDuration: Double = 0.1
    
    // Stores the size of a segment, used to create the active segment rect
    @State private var segmentSize: CGSize = .zero
    // Rounded rectangle to denote active segment
    @ViewBuilder
    private var activeSegmentView: some View {
        // Don't show the active segment until we have initialized the view
        // This is required for `.animation()` to display properly, otherwise the animation will fire on init
        let isInitialized: Bool = segmentSize != .zero
        if !isInitialized { EmptyView() }
        else {
            RoundedRectangle(cornerRadius: SegmentedPicker.SegmentCornerRadius)
                .foregroundColor(SegmentedPicker.ActiveSegmentColor)
                .frame(width: self.segmentSize.width, height: self.segmentSize.height)
                .offset(x: self.computeActiveSegmentHorizontalOffset(), y: 0)
                .animation(Animation.linear(duration: SegmentedPicker.AnimationDuration))
        }
    }
    
    @Binding private var selection: Int
    private let items: [String]
    
    init(items: [String], selection: Binding<Int>) {
        self._selection = selection
        self.items = items
    }
    
    var body: some View {
        // Align the ZStack to the leading edge to make calculating offset on activeSegmentView easier
        ZStack(alignment: .leading) {
            // activeSegmentView indicates the current selection
            self.activeSegmentView
            HStack {
                ForEach(0..<self.items.count, id: \.self) { index in
                    self.getSegmentView(for: index)
                }
            }
        }
        .padding(SegmentedPicker.PickerPadding)
        .background(SegmentedPicker.BackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: SegmentedPicker.SegmentCornerRadius))
    }

    // Helper method to compute the offset based on the selected index
    private func computeActiveSegmentHorizontalOffset() -> CGFloat {
        CGFloat(self.selection) * (self.segmentSize.width + SegmentedPicker.SegmentXPadding)
    }

    // Gets text view for the segment
    @ViewBuilder
    private func getSegmentView(for index: Int) -> some View {
        if index >= self.items.count {
            EmptyView()
        } else {
            Text(self.items[index])
                // Dark test for selected segment
                .foregroundColor(
                    SegmentedPicker.TextColor)
                .font(SegmentedPicker.TextFont)
                .lineLimit(1)
                .padding(.vertical, SegmentedPicker.SegmentYPadding)
                .padding(.horizontal, SegmentedPicker.SegmentXPadding)
                .frame(minWidth: 0, maxWidth: .infinity)
                // Watch for the size of the
                .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
                .onTapGesture { self.onItemTap(index: index) }
        }
    }

    // On tap to change the selection
    private func onItemTap(index: Int) {
        guard index < self.items.count else {
            return
        }
        self.selection = index
    }
    
}

struct AccountView: View {
    @State var selection: Int = 0
    private let items: [String] = ["Sign In", "Register"]
    
    var body: some View {
        NavigationView {
            VStack {
                ToolbarView(title: "Seedling")
                    .padding(.top)
                SegmentedPicker(items: self.items, selection: self.$selection)
                    .padding(.horizontal, 80)
                    .padding(.vertical, 20)
                LoginView()
                    .padding(.top, 20)
                    .padding(.horizontal, 40)
                GeometryReader { geometry in
                    Image("background")
                        .resizable()
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        // .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        .clipped()
                }.ignoresSafeArea()
                .padding(.top, 50)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

#if DEBUG
struct AccountPreview: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
#endif
