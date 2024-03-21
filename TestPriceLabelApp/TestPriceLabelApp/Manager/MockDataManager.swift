import Foundation

final class MockDataManager {}

extension MockDataManager: PriceLabelDataService {
    func getAllData() -> [PriceLabelDataModel] {
        let json = """
        [
            {
                "id": "tovar1",
                "name": "Товар 1",
                "description": "Это какой-то очень чудесный товар для того, чтобы вы его купили",
                "price": 100
            },
            {
                "id": "car",
                "name": "Машинка с названием, которое скорее всего не влезет в одну строку на очень маленьком экране iPhone",
                "description": "Зато описание у этой машинки очень даже короткое",
                "price": 10000.23
            },
            {
                "id": "flower",
                "name": "Букет цветов",
                "description": "В нем и гвоздики, и герани, и даже чуть цветов акации. Пахнет просто замечательно! И долго радует глаз...",
                "price": 77.24
            },
            {
                "id": "eda",
                "name": "Набор на ужин",
                "description": "Колбаса и немного хлеба. Возможно, если очень повезет, будет еще и масло. Обязательно будет и черный чай с сахаром из стакана в подстаканнике (но его вы купите сами).",
                "price": 77.24
            }

        ]

        """

        let data = json.data(using: .utf8)!
        return try! JSONDecoder().decode([PriceLabelDataModel].self, from: data)
    }


}
