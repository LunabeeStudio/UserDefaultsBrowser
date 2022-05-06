//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/03.
//

import SwiftPrettyPrint
import SwiftUI

struct RowView: View {
    @Environment(\.customAccentColor) private var customAccentColor

    private var defaults: UserDefaultsContainer
    private var key: String
    private var onUpdate: () -> Void

    init(defaults: UserDefaultsContainer, key: String, onUpdate: @escaping () -> Void) {
        self.defaults = defaults
        self.key = key
        self.onUpdate = onUpdate
    }

    @State private var isPresentedEditSheet = false

    private var value: (pretty: String, raw: String?) {
        let value = defaults.lookup(forKey: key)

        switch value {
        //
        // 💡 Note:
        // `Array` and `Dictionary` are display as JSON string.
        // Because editor of `[String: Any]` is input as JSON.
        //
        case let value as [Any]:
            return (value.prettyJSON, nil)
        case let value as [String: Any]:
            return (value.prettyJSON, nil)
        case let value as JSONData:
            return (value.dictionary.prettyJSON, "<Decoded JSON Data>")
        case let value as JSONString:
            return (value.dictionary.prettyJSON, "<Decoded JSON String>")

        default:
            return (prettyString(value), nil)
        }
    }

    private var exportString: String {
        """

        \(key)

        \(value.pretty + (value.raw.map { "\n" + $0 } ?? ""))
        """
    }

    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading) {
                    Text(value.pretty)
                    if let raw = value.raw {
                        Text(raw)
                            .foregroundColor(.gray)
                            .padding(.top, 2)
                    }
                }
                Spacer()
            }
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .font(.codeStyle)
            .padding(.top, 2)
        } label: {
            HStack {
                Text(key)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .foregroundColor(.gray)
                Spacer()

                Group {
                    //
                    // 􀈊 Edit
                    //
                    Button {
                        isPresentedEditSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }

                    //
                    // 􀩼 Console
                    //
                    Button {
                        print(exportString)
                    } label: {
                        Image(systemName: "terminal")
                    }

                    //
                    // 􀉁 Copy
                    //
                    Button {
                        UIPasteboard.general.string = exportString
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .sheet(isPresented: $isPresentedEditSheet, onDismiss: { onUpdate() }) {
            ValueEditView(defaults: defaults, key: key)
                //
                // ⚠️ SwiftUI Bug: AccentColor is not inherited to sheet.
                //
                .accentColor(customAccentColor)
        }
    }
}

private func prettyString(_ value: Any?) -> String {
    guard let value = value else { return "nil" }

    var option = Pretty.sharedOption
    option.indentSize = 2

    var output = ""
    Pretty.prettyPrintDebug(value, option: option, to: &output)
    return output
}
