//
//  BonjourPrinterBrowser.swift
//  PrinterApp
//
//  Created by IVANKIS on 02.07.2024.
//

import Foundation

class BonjourPrinterBrowser: NSObject, ObservableObject, NetServiceBrowserDelegate, NetServiceDelegate {
    @Published var printers: [Printer] = []

    private var netServiceBrowser: NetServiceBrowser?
    private var foundServices: [NetService] = []

    override init() {
        super.init()
        netServiceBrowser = NetServiceBrowser()
        netServiceBrowser?.delegate = self
    }

    func startBrowsing() {
        netServiceBrowser?.searchForServices(ofType: "_ipp._tcp", inDomain: "local.")
    }

    func stopBrowsing() {
        netServiceBrowser?.stop()
    }

    // MARK: - NetServiceBrowserDelegate

    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        foundServices.append(service)
        service.delegate = self
        service.resolve(withTimeout: 10.0)
    }

    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        if let index = foundServices.firstIndex(of: service) {
            foundServices.remove(at: index)
            printers.removeAll { $0.name == service.name }
        }
    }

    // MARK: - NetServiceDelegate

    func netServiceDidResolveAddress(_ sender: NetService) {
        guard let hostName = sender.hostName else { return }
        let printer = Printer(name: sender.name, ipAddress: hostName)
        DispatchQueue.main.async {
            self.printers.append(printer)
        }
    }

    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        if let index = foundServices.firstIndex(of: sender) {
            foundServices.remove(at: index)
        }
    }
}
