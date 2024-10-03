//
//  NotificationDetailUseCase.swift
//  NotificationFeature
//
//  Created by sejin on 2023/06/16.
//  Copyright © 2023 SOPT-iOS. All rights reserved.
//

import Combine

import Core

public protocol NotificationDetailUseCase {
    var readSuccess: PassthroughSubject<Bool, Error> { get }
    var notificationDetail: PassthroughSubject<NotificationDetailModel, Never> { get }
    
    func readNotification(notificationId: String)
    func getNotificationDetail(notificationId: String)
}

public class DefaultNotificationDetailUseCase {
  
    private let repository: NotificationDetailRepositoryInterface
    private var cancelBag = CancelBag()
    
    public let readSuccess = PassthroughSubject<Bool, Error>()
    public let notificationDetail = PassthroughSubject<NotificationDetailModel, Never>()
  
    public init(repository: NotificationDetailRepositoryInterface) {
        self.repository = repository
    }
}

extension DefaultNotificationDetailUseCase: NotificationDetailUseCase {
    
    public func readNotification(notificationId: String) {
        repository.readNotification(notificationId: notificationId)
            .withUnretained(self)
            .sink { event in
                print("ReadNotification State: \(event)")
            } receiveValue: { owner, readSuccess in
                owner.readSuccess.send(readSuccess)
            }.store(in: self.cancelBag)
    }
    
    public func getNotificationDetail(notificationId: String) {
        repository.getNotificationDetail(notificationId: notificationId)
            .withUnretained(self)
            .sink { event in
                print("ReadNotification State: \(event)")
            } receiveValue: { owner, notificationDetail in
                owner.notificationDetail.send(notificationDetail)
            }.store(in: self.cancelBag)

    }
}
