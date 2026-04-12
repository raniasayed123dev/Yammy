import UIKit

class MenuViewController: UIViewController {
    private let viewModel = MenuViewModel()
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var menuItems : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        bindViewModel()
        viewModel.fetchMeals(for: menuItems)
        menuLabel.text = menuItems
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension MenuViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMeals()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuTableViewCell
        let meal = viewModel.meal(at: indexPath.row)
        let priceText = viewModel.priceText(for: meal)
        let isFav = DataManager.shared.isFavorite(meal: meal)
        cell.configure(with: meal, priceText: priceText, isFavorite: isFav)
        
        cell.onFavoriteClick = { [weak self] in
            guard let self = self else { return }
            let meal = self.viewModel.meal(at: indexPath.row)
            DataManager.shared.toggleFavorite(meal: meal)
            tableView.reloadData()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeal = viewModel.meal(at: indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "MealDetailsViewController") as? MealDetailsViewController {
            detailsVC.selectedMeal = selectedMeal
            navigationController?.pushViewController(detailsVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
