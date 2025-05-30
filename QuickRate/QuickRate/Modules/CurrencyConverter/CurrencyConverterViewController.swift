//
//  ViewController.swift
//  QuickRate
//
//  Created by Nikolay Gilvey on 29.05.25.
//

import UIKit
import SnapKit
import Combine

enum ButtonType: Int {
    case from = 0
    case to
}

final class CurrencyConverterViewController: UIViewController {
    
    private let viewModel: CurrencyConverterViewModel
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.applyCurrencyStyle()
        return textField
    }()
    
    private let resultTextField: UITextField = {
        let textField = UITextField()
        textField.applyCurrencyStyle()
        return textField
    }()
    
    private let fromCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BYN", for: .normal)
        button.applyCurrencyButtonStyle()
        button.tag = ButtonType.from.rawValue
        return button
    }()
    
    private let toCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("USD", for: .normal)
        button.applyCurrencyButtonStyle()
        button.tag = ButtonType.to.rawValue
        return button
    }()
    
    private lazy var switchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.applySwitchButtonStyle()
        button.addTarget(self, action: #selector(switchCurrencies), for: .touchUpInside)
        return button
    }()
    
    private let leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let currencyOptions = ["USD", "BYN", "EUR", "RUB"]
    private let mainStack = UIStackView()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CurrencyConverterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBindings()
        setupCurrencyMenus()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.updateMainStackLayoutConstraints()
    }
    
    private func setupCurrencyMenus() {
        configureMenu(for: fromCurrencyButton)
        configureMenu(for: toCurrencyButton)
    }
    
    private func configureMenu(for button: UIButton) {
        button.menu = UIMenu(children: currencyOptions.map {
            UIAction(title: $0) { [weak self] action in
                guard let self else { return }
                button.setTitle(action.title, for: .normal)
                switch ButtonType(rawValue: button.tag) {
                case .from:
                    self.viewModel.fromCurrency = action.title
                case .to:
                    self.viewModel.toCurrency = action.title
                case .none:
                    break
                }
                self.viewModel.getExchangeRate(for: self.amountTextField.text ?? "")
            }
        })
        button.showsMenuAsPrimaryAction = true
    }
    
    private func addSubviews() {
        let amountStack = UIStackView(arrangedSubviews: [amountTextField, fromCurrencyButton])
        amountStack.axis = .horizontal
        amountStack.spacing = 10
        
        let resultStack = UIStackView(arrangedSubviews: [resultTextField, toCurrencyButton])
        resultStack.axis = .horizontal
        resultStack.spacing = 10
        
        let switchStack = UIStackView(arrangedSubviews: [leftLine, switchButton, rightLine])
        switchStack.axis = .horizontal
        switchStack.spacing = 12
        switchStack.alignment = .center
        
        mainStack.axis = .vertical
        mainStack.spacing = 18
        mainStack.addArrangedSubview(amountStack)
        mainStack.addArrangedSubview(switchStack)
        mainStack.addArrangedSubview(resultStack)
        
        view.addSubview(mainStack)
    }
    
    private func setupConstraints() {
        updateMainStackLayoutConstraints()
        
        [amountTextField, resultTextField].forEach {
            $0.snp.makeConstraints { $0.height.equalTo(44) }
        }
        
        [fromCurrencyButton, toCurrencyButton].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(80)
                $0.height.equalTo(44)
            }
        }
        
        switchButton.snp.makeConstraints {
            $0.size.equalTo(40)
        }
        
        rightLine.snp.makeConstraints {
            $0.width.equalTo(leftLine)
        }
    }
    
    private func updateMainStackLayoutConstraints() {
        mainStack.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            
            let isPortrait: Bool = {
                if UIDevice.current.orientation.isValidInterfaceOrientation {
                    return UIDevice.current.orientation.isPortrait
                } else {
                    return view.bounds.height >= view.bounds.width
                }
            }()
            
            if traitCollection.horizontalSizeClass == .compact && isPortrait {
                $0.left.right.equalToSuperview().inset(20)
            } else {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(350)
            }
        }
    }
}
    
// MARK: - Setup Bindigs

private extension CurrencyConverterViewController {
    func setupBindings() {
        amountTextField.textPublisher
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.viewModel.getExchangeRate(for: text)
            }
            .store(in: &cancellables)
        
        viewModel.$convertedValue
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                self?.resultTextField.text = result
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.showAlert(message: message)
            }
            .store(in: &cancellables)
    }
}

// MARK: - funcs

private extension CurrencyConverterViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    @objc
    func switchCurrencies() {
        let old = viewModel.fromCurrency
        viewModel.fromCurrency = viewModel.toCurrency
        viewModel.toCurrency = old
        fromCurrencyButton.setTitle(viewModel.fromCurrency, for: .normal)
        toCurrencyButton.setTitle(viewModel.toCurrency, for: .normal)
        viewModel.getExchangeRate(for: amountTextField.text ?? "")
    }
}
