import Foundation

class ComicBasic: Decodable {
    var title: String
    var thumb: String
//    var type: String

    init(title: String, thumb: String) {
        self.title = title
        self.thumb = thumb
//        self.type = type
    }

    // Implement init(from decoder: Decoder) required by Decodable protocol
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.thumb = try container.decode(String.self, forKey: .thumb)
//        self.type = try container.decode(String.self, forKey: .type)
    }

    // CodingKeys enum to specify the keys used for decoding
    private enum CodingKeys: String, CodingKey {
        case title
        case thumb
//        case type
    }
}
struct ComicResponse: Decodable {
    let manga_list: [ComicBasic]
}
