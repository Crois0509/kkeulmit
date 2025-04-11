//
//  APITest.swift
//  kkeulmitTests
//
//  Created by 장상경 on 4/10/25.
//

import XCTest
@testable import kkeulmit

final class APITest: XCTestCase {
    
    private var sut: APIManagable!

    override func setUpWithError() throws {
        sut = APIManager()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGetMethod() async throws {
        // given & when
        do {
            let data = try await sut.fetch()
            
            // then
            debugPrint("✅ 날씨 데이터 변환 성공, 데이터 수:", data.list.count)
            XCTAssertNotNil(data)
        } catch {
            debugPrint("🚨 날씨 데이터 변환 실패", error.localizedDescription)
            XCTFail("API 요청 실패: \(error)")
        }
    }


}
