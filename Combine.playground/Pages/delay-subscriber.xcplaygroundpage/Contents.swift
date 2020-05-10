import Cocoa
import Combine
import PlaygroundSupport

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

let logger = Logger()

class CustomSubscriber: Subscriber {
    typealias Input = Date
    typealias Failure = Never
    
    private var subscription: Subscription?
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
        self.subscription = subscription
    }

    func receive(_ input: Date) -> Subscribers.Demand {
        logger.writeLine("subscriber: receive \(input)")
        return .unlimited
    }

    func receive(completion: Subscribers.Completion<Never>) {
        logger.writeLine("subscriber: completion \(completion)")
    }
    
    func cancel() {
        logger.writeLine("subscriber: cancel")
        subscription?.cancel()
        subscription = nil
    }
}

let delayedTimer = Timer.publish(every: 1.4, on: .main, in: .default).autoconnect() // or Just(Date())
    .print("timer", to: logger)
    .delay(for: .seconds(5), scheduler: RunLoop.main)
    .print("delay", to: logger)
    .eraseToAnyPublisher()

let subscriber = CustomSubscriber()
var subscriberCancellable: AnyCancellable?
delayedTimer
    .subscribe(subscriber)

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
    subscriber.cancel()
    logger.writeLine("---- cancel ----")
}

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(15)) {
    logger.writeLine("Playground Finished")
    page.finishExecution()
}
