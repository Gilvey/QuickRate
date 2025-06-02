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
    
    private lazy var resultTextField = TextField(placeHolder: "Converted amount", isEnable: false)
    
    private lazy var fromCurrencyButton = Button(style: .currencyButton)
    
    private lazy var toCurrencyButton = Button(style: .currencyButton)
    
    private lazy var switchButton: Button = {
        let button = Button(style: .switchButton, image: UIImage(.arrowUpArrowDown))
        button.addTarget(self, action: #selector(switchCurrencies), for: .touchUpInside)
        return button
    }()
    
    private lazy var leftLine = LineView(color: .lightGray)
    
    private lazy var rightLine = LineView(color: .lightGray)
    
    private lazy var mainStack = UIStackView()
    
    private let viewModel: CurrencyConverterViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private var isCurrencyMenuSetup = false
    
    private var mainStackCenterYConstraint: Constraint?
    private var isKeyBoardPresented = false
    
    init(viewModel: CurrencyConverterViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Currency Converter"
        setupBindings()
        viewModel.send(.fetchCurrencies)
        addSubviews()
        setupConstraints()
        setupDismissGesture()
        observeKeyBoardChanges()
    }
    
    // MARK: - UI Setup
    
    private func addSubviews() {
        let amountStack = UIStackView(
            arrangedSubviews: [amountTextField, fromCurrencyButton],
            axis: .horizontal,
            spacing: 10
        )
        
        let resultStack = UIStackView(
            arrangedSubviews: [resultTextField, toCurrencyButton],
            axis: .horizontal,
            spacing: 10
        )
        
        let switchStack = UIStackView(
            arrangedSubviews: [leftLine, switchButton, rightLine],
            axis: .horizontal,
            spacing: 12,
            alignment: .center
        )
        
        mainStack.axis = .vertical
        mainStack.spacing = 18
        mainStack.addArrangedSubview(amountStack)
        mainStack.addArrangedSubview(switchStack)
        mainStack.addArrangedSubview(resultStack)
        
        view.addSubview(mainStack)
    }
    
    private func setupConstraints() {
        mainStack.snp.remakeConstraints {
            if isIphone {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
                $0.left.right.equalToSuperview().inset(20)
            } else {
                $0.centerX.equalToSuperview()
                mainStackCenterYConstraint = $0.centerY.equalToSuperview().constraint
                $0.width.equalTo(350)
            }
        }
        
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
    
    private func setupDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Currency Menus
    
    private func setupCurrencyMenus(with currencyOptions: [String]) {
        fromCurrencyButton.tag = ButtonTag.from.rawValue
        toCurrencyButton.tag = ButtonTag.to.rawValue
        configureMenu(for: fromCurrencyButton, with: currencyOptions)
        configureMenu(for: toCurrencyButton, with: currencyOptions)
    }
    
    private func configureMenu(for button: UIButton, with currencyOptions: [String]) {
        button.menu = UIMenu(
            children: currencyOptions.map {
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
                
                self.setLoading(isLoading: state.isLoading)
                
                if let currencies = state.currencies, self.isCurrencyMenuSetup == false {
                    self.fromCurrencyButton.setTitle(currencies.first, for: .normal)
                    self.toCurrencyButton.setTitle(currencies.dropFirst().first, for: .normal)
                    self.setupCurrencyMenus(with: currencies)
                    self.isCurrencyMenuSetup = true
                }
                
                if let (fromCurrency, toCurrency) = state.switchedCurrencies {
                    fromCurrencyButton.setTitle(fromCurrency, for: .normal)
                    toCurrencyButton.setTitle(toCurrency, for: .normal)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - User Interaction

private extension CurrencyConverterViewController {
    @objc
    func switchCurrencies() {
        viewModel.send(.switchCurrencies(currentAmount: amountTextField.text ?? ""))
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Keyboard Handling

private extension CurrencyConverterViewController {
    func observeKeyBoardChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let timeInterval = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        
        let stackFrameInWindow = mainStack.convert(mainStack.bounds, to: view.window)
        let stackBottomY = stackFrameInWindow.maxY
        let keyboardTopY = keyboardFrame.minY
        
        let overlap = stackBottomY - keyboardTopY
        
        guard overlap > 0 else { return }
        
        let padding: CGFloat = 16
        let offset = overlap + padding
        
        mainStackCenterYConstraint?.update(offset: -offset)
        
        UIView.animate(withDuration: timeInterval ?? 0) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        mainStackCenterYConstraint?.update(offset: 0)
        
        let timeInterval = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? TimeInterval
        
        UIView.animate(withDuration: timeInterval ?? 0) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Loading Indicator

private extension CurrencyConverterViewController {
    func setLoading(isLoading: Bool) {
        view.isUserInteractionEnabled = !isLoading
        let image = isLoading ? UIImage(.loader) : UIImage(.arrowUpArrowDown)
        
        switchButton.setImage(image, for: .normal)
        
        if isLoading {
            startRotating(for: switchButton.imageView ?? switchButton)
        } else {
            stopRotation(for: switchButton.imageView ?? switchButton)
        }
    }
}
