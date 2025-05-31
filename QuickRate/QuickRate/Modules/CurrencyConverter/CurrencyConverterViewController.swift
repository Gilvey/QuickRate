//
//  ViewController.swift
//  QuickRate
//
//  Created by Nikolay Gilvey on 29.05.25.
//

import UIKit
import SnapKit
import Combine

enum ButtonTag: Int {
    case from = 0
    case to
}

final class CurrencyConverterViewController: UIViewController {
    
    private lazy var amountTextField = TextField(placeHolder: "Enter amount")
    
    private lazy var resultTextField = TextField(placeHolder: "Converted amount")
    
    private lazy var fromCurrencyButton = Button(type: .currencyButton)
    
    private lazy var toCurrencyButton = Button(type: .currencyButton)
    
    private lazy var switchButton: Button = {
        let button = Button(type: .switchButton, image: ImageManager.arrowUpArrowDown)
        button.addTarget(self, action: #selector(switchCurrencies), for: .touchUpInside)
        return button
    }()
    
    private lazy var leftLine = LineView(color: .lightGray)
    
    private lazy var rightLine = LineView(color: .lightGray)
    
    private lazy var mainStack = UIStackView()
    
    private let viewModel: CurrencyConverterViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private var isCurrencyMenuSetup = false
    
    init(viewModel: CurrencyConverterViewModelProtocol) {
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
        viewModel.send(.fetchCurrencies)
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.updateMainStackLayoutConstraints()
    }
    
    private func setupCurrencyMenus() {
        fromCurrencyButton.tag = ButtonTag.from.rawValue
        toCurrencyButton.tag = ButtonTag.to.rawValue
        configureMenu(for: fromCurrencyButton)
        configureMenu(for: toCurrencyButton)
    }
    
    private func configureMenu(for button: UIButton) {
        button.menu = UIMenu(
            children: viewModel.currencyOptions.map {
                UIAction(title: $0) { [weak self] action in
                    guard let self else { return }
                    button.setTitle(action.title, for: .normal)
                    if let tag = ButtonTag(rawValue: button.tag) {
                        viewModel.send(
                            .selectCurrency(
                                type: tag,
                                value: action.title,
                                currentAmount: amountTextField.text ?? ""
                            )
                        )
                    }
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
    
// MARK: - Bindings

private extension CurrencyConverterViewController {
    func setupBindings() {
        amountTextField.textPublisher
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.viewModel.send(.amountChanged(text))
            }
            .store(in: &cancellables)
        
        viewModel.state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.resultTextField.text = state.convertedValue
                
                if let message = state.errorMessage {
                    self.showAlert(message: message)
                }
                
                if let currencies = state.currencies, self.isCurrencyMenuSetup == false {
                    self.fromCurrencyButton.setTitle(currencies.first, for: .normal)
                    self.toCurrencyButton.setTitle(currencies.dropFirst().first, for: .normal)
                    self.setupCurrencyMenus()
                    self.isCurrencyMenuSetup = true
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Actions

private extension CurrencyConverterViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    @objc
    func switchCurrencies() {
        viewModel.send(.switchCurrencies(currentAmount: amountTextField.text ?? ""))
        fromCurrencyButton.setTitle(viewModel.fromCurrency, for: .normal)
        toCurrencyButton.setTitle(viewModel.toCurrency, for: .normal)
    }
}
