//
//  NutritionStatisticsViewController.swift
//  konmechu
//
//  Created by 정재연 on 10/25/23.
//

import UIKit
import FSCalendar

class NutritionStatisticsViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Table view Data var
    var menuList = MenuData.yesterdayData
    
    var menuSections : [MenuSection] = []
    
    
    //MARK: - Calendar var
    
    
    @IBOutlet weak var calendarStackView: UIStackView!
    
    @IBOutlet weak var dayIdxBtn: UIButton!
    
    @IBOutlet weak var FSCalendarView: FSCalendar!
    
    private var dateFormatter : DateFormatter?
    
    
    //MARK: - Nutritioin info var
    
    @IBOutlet weak var nutritionBaseView: UIView!
    
    
    
    @IBOutlet weak var kcalView: UIView!
    
    @IBOutlet weak var carbohydrateView: UIView!
    
    @IBOutlet weak var proteinView: UIView!
    
    @IBOutlet weak var fatView: UIView!
    
    @IBOutlet weak var sugarsView: UIView!
    
    
    
    @IBOutlet weak var kcalLabel: UILabel!
    
    @IBOutlet weak var carbohydrateLabel: UILabel!
    
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var fatLabel: UILabel!
    
    @IBOutlet weak var sugarsLabel: UILabel!
    
    private var nutritionViews: [UIView] = []

    
    //MARK: - menu list table view
    
    @IBOutlet weak var menuTableView: UITableView!
    
    @IBOutlet weak var menuTableViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCalendar()
        setUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTableViewHeight()
    }
    
    
    
    //MARK: - initial UI setting func
    
    func setUI() {
        
        dayIdxBtn.setTitle(dateFormatter?.string(from: FSCalendarView.today!), for: .normal)
        
        setNutritionInfoViewUI()
        setMenuTableViewUI()
        setMenuTableView()
        
        self.view.bringSubviewToFront(calendarStackView)
    }
    
    //MARK: - menuTableView
    
    private func setTableViewHeight() {
        var tableViewHeight: CGFloat = 10

        for section in 0..<menuTableView.numberOfSections {
            if menuSections[section].menus.count == 0 {continue}
            tableViewHeight += 55
            for row in 0..<menuTableView.numberOfRows(inSection: section) {
                tableViewHeight += 100
            }
        }

        menuTableViewHeight.constant = tableViewHeight
    }
    
    private func setMenuTableViewUI() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        registerXib()
        
        menuTableView.layer.cornerRadius = 20
        
        menuTableView.backgroundColor = menuTableView.backgroundColor?.withAlphaComponent(0.2)
        
        menuTableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        menuTableView.layer.shadowOpacity = 0.7
        
        menuTableView.separatorStyle = .none
    }
    
    private func setMenuTableView() {
        
        menuSections.removeAll()
        
        for mealTime in MealTime.allCases {
            let filteredMenus = menuList.filter { $0.mealTime == mealTime }
            let section = MenuSection(mealTime: mealTime, menus: filteredMenus)
            menuSections.append(section)
        }
        
        DispatchQueue.main.async {
            self.menuTableView.reloadData()
            self.setTableViewHeight()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSections[section].menus.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuSections.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! menuTableViewCell
        
        let target = menuSections[indexPath.section].menus[indexPath.row]
               
        let img = UIImage(named: "\(target.image).png")
        cell.menuImgView?.image = img
        cell.mealTimeLabel?.text = target.title
        cell.backgroundColor = UIColor.clear.withAlphaComponent(0)
                
        cell.selectionStyle = .none

               
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if menuSections[section].menus.count == 0 {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear// 배경색 설정
           
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16) // 글꼴 크기 설정
        headerLabel.textColor = UIColor.white // 글자색 설정
        
        let sectionTitle = menuSections[section].mealTime.rawValue
        headerLabel.text = sectionTitle // 섹션 타이틀 설정
        
           headerLabel.textAlignment = .center // 텍스트 정렬 설정
           
           headerView.addSubview(headerLabel)
           
           return headerView
       }
       
    
    let cellName = "menuTableViewCell"
    let cellReuseIdentifier = "menuCell"
    
    private func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        menuTableView.register(nibName, forCellReuseIdentifier: cellReuseIdentifier)
    }

    
    //MARK: - NutritionInfoView
    func setNutritionInfoViewUI() {
        
        nutritionBaseView.layer.cornerRadius = 20
        
        nutritionBaseView.backgroundColor = nutritionBaseView.backgroundColor?.withAlphaComponent(0.2)
        
        nutritionBaseView.layer.shadowOffset = CGSize(width: 0, height: 0)
        nutritionBaseView.layer.shadowOpacity = 0.7
        
        nutritionViews.append(kcalView)
        nutritionViews.append(carbohydrateView)
        nutritionViews.append(proteinView)
        nutritionViews.append(fatView)
        nutritionViews.append(sugarsView)
        
        for view in nutritionViews {
            view.layer.cornerRadius = view.layer.bounds.width / 2
            view.backgroundColor = view.backgroundColor?.withAlphaComponent(0.2)
            view.layer.borderWidth = 2
            view.layer.borderColor = view.backgroundColor?.withAlphaComponent(1).cgColor

        }
    }
    
    //MARK: - calendar setting
    
    func setCalendar() {
        FSCalendarView.delegate = self
        FSCalendarView.dataSource = self
        
        dateFormatter = DateFormatter()
        dateFormatter?.dateFormat = "YYYY년 MM월 dd일"
        
        FSCalendarView.locale = Locale(identifier: "ko_KR")
        
        FSCalendarView.appearance.headerDateFormat = "YYYY년 MM월"
        
        FSCalendarView.appearance.headerTitleAlignment = .center

        FSCalendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
        FSCalendarView.headerHeight = 45
        
        FSCalendarView.appearance.headerTitleFont = UIFont(name: "NotoSansKR-Medium", size: 16)
        FSCalendarView.appearance.headerTitleColor = .white

        FSCalendarView.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 14)
        FSCalendarView.appearance.weekdayTextColor = .white
        
        FSCalendarView.appearance.titleFont = UIFont.boldSystemFont(ofSize: 14)
        
        FSCalendarView.backgroundColor = FSCalendarView.backgroundColor?.withAlphaComponent(0.2)
        
        FSCalendarView.layer.cornerRadius = 30
        FSCalendarView.clipsToBounds = true
        
        FSCalendarView.layer.shadowOpacity = 0.5
        FSCalendarView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        FSCalendarView.isHidden = true
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dayIdxBtn.setTitle(dateFormatter?.string(from: date), for: .normal)
        menuList = MenuData.todayData
        setMenuTableView()
    }
    
    //MARK: - btn acction func
    
    
    @IBAction func dayBtnDidTap(_ sender: Any) {

        if let overlayView = self.view.viewWithTag(100) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.FSCalendarView.alpha = 0
                    overlayView.alpha = 0
                }) { _ in
                    self.FSCalendarView.isHidden = true
                    overlayView.removeFromSuperview()
                }
                return
            }

            // 새로운 오버레이 뷰를 생성합니다.
            let overlayView = UIView(frame: self.view.bounds)
            overlayView.backgroundColor = UIColor(named: "mainColor") // 투명도를 50%로 설정
            overlayView.tag = 100 // 나중에 오버레이 뷰를 쉽게 찾기 위한 태그
            overlayView.alpha = 0 // 초기 알파 값을 0으로 설정하여 뷰가 보이지 않게 합니다.
            overlayView.isUserInteractionEnabled = false // 오버레이 뷰가 이벤트를 받지 않도록 설정합니다.

            // 오버레이 뷰를 현재 뷰 컨트롤러의 뷰에 추가합니다.
            self.view.addSubview(overlayView)
            self.view.bringSubviewToFront(self.calendarStackView)

            // 애니메이션을 사용하여 오버레이 뷰와 캘린더 뷰를 서서히 표시합니다.
            UIView.animate(withDuration: 0.3, animations: {
                self.FSCalendarView.isHidden = false
                self.FSCalendarView.alpha = 1
                overlayView.alpha = 1 // 오버레이 뷰를 투명도 50%로 설정하여 부분적으로 보이게 합니다.
            })
        
    }
    
    
}
