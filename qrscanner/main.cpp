#include <iostream>
#include <opencv2/opencv.hpp>
#include <json.hpp>               // json serializing and deserializing
#include <cpr/cpr.h>              // post requests
#include <fstream>                // read in config file

using json = nlohmann::json;

int main() {
    
    cv::VideoCapture capture(0);
    capture.set(cv::CAP_PROP_BUFFERSIZE, 2);
    if (!capture.isOpened()) {
        std::cerr << "ERROR: Could not open camera" << std::endl;
        return -1;
    }

    cv::QRCodeDetector qrDecoder = cv::QRCodeDetector();
    cv::Mat frame;
    bool scanned = false;
    unsigned int scanCount = 0;
    auto last_scan {json::parse(R"({"init": "init"})")};
    std::ifstream config_file("../config.json");
    auto config = json::parse(config_file);

    // display the frame until you press a key
    while (capture.read(frame)) {
        if (frame.empty()) {
            std::cout << "No frames were captured. Shutting down..." << std::endl;
            return -1;
        }

        try {
            std::string data = qrDecoder.detectAndDecode(frame);

            if (data.length() > 0) {
                auto j = json::parse(data);
                if (j != last_scan) {
                    std::cout << "Item scanned" << std::endl;
                    cpr::Response r = cpr::Post(cpr::Url{"http://0.0.0.0:8080/api/update"},
                                                cpr::Payload{
                                                        {"id", j["id"].get<std::string>()},
                                                        {"account",config["account"].get<std::string>()},
                                                        {"location", config["location"].get<std::string>()}
                    });
                    last_scan = j;
                    scanned = true;
                } else {
                    std::cout << "Already scanned" << std::endl;
                }
            }
        } catch (nlohmann::json::parse_error& e) {
            std::cout << e.what();
        } catch (cv::Exception& e) {
            std::cout << e.what();
        }

        if (!scanned) {
            cv::putText(frame,
                        "Scan QR",
                        cv::Point(10, frame.rows - 10),
                        cv::FONT_HERSHEY_SIMPLEX,
                        1,
                        CV_RGB(250, 255, 250),
                        3);
        } else {
            cv::putText(frame,
                        "QR Scanned",
                        cv::Point(10, frame.rows - 10),
                        cv::FONT_HERSHEY_SIMPLEX,
                        1,
                        CV_RGB(50, 255, 100),
                        3);
            if (scanCount < 10) {
                scanCount++;
            } else {
                scanned = false;
                scanCount = 0;
            }
        }

        cv::imshow("QR Scanner", frame);

        if(cv::waitKey(10) == 27) {
            std::cout << "\nESC key was pressed. Shutting down..." << std::endl;
            return 0;
        }



    }

    return 0;
}