import Cocoa
import Combine
import PlaygroundSupport

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

let logger = Logger()

let delayedTimer = Timer.publish(every: 1.4, on: .main, in: .default).autoconnect() // or Just(Date())
    .print("timer", to: logger)
    .delay(for: .seconds(5), scheduler: RunLoop.main)
    .print("delay", to: logger)
    .eraseToAnyPublisher()

var sinkCancellable: AnyCancellable?
sinkCancellable = delayedTimer
    .sink {
        logger.writeLine("value \($0)")
    }

DispatchQueue.main
    .asyncAfter(deadline: .now() + .seconds(3)) {
        sinkCancellable = nil
        logger.writeLine("---- cancel ----")
    }

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(15)) {
    logger.writeLine("Playground Finished")
    page.finishExecution()
}
