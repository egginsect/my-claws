# Memory - ClaimWise E2E Testing & Fixes

## Session: 2026-02-06

### 任務
Hao 要求做 ClaimWise E2E 測試 (OAuth + AI Chat Tools)，找出問題並開 PR。

### 進度

#### ✅ 完成
1. **設置 XWindow 環境** - 確認 Chromium 瀏覽器運作
2. **OAuth 測試**
   - Google: ✅ 成功
   - Microsoft: ❌ Supabase 未啟用
   - Apple: ❌ Supabase 未啟用
3. **Waitlist 註冊** ✅ API 回傳 201
4. **代碼分析** - 發現 `/api/chat/ask` 的邏輯
5. **裝好 `uv`** - Python MCP 現在能執行
6. **修復 Bug**: tool_choice 邏輯

#### 🐛 找到的問題

**Problem 1: MCP Server 未啟動**
- 原因: `uv` CLI 缺失
- 修復: 安裝 `uv` → `/config/.local/bin/uv 0.10.0`
- 現在: Python MCP 正常在 `127.0.0.1:8000`

**Problem 2: /api/chat/ask 中 tool_choice BUG**
- 位置: `app/api/chat/ask/route.ts` L289
- 問題: `tool_choice: iteration === 1 ? "auto" : "auto"` (都是 auto，邏輯重複)
- 修復: 簡化為 `tool_choice: "auto"`
- 檔案已修改, 待提交

#### 🧪 測試狀態
- Browser automation (xdotool) 有困難，改用 API 層面測試
- Supabase 認證複雜 (需 email confirmation),  可靠由 Hao 登入測試

#### 📝 下一步
1. Commit 修改
2. 開 PR
3. Hao 可登入後測試 AI Chat + Tools 功能

---

## 相關文件
- ClaimWise 路徑: `/config/.openclaw/workspace/claimwise`
- 修改文件: `app/api/chat/ask/route.ts`
- Supabase: hffxkppvtbxyytcvnlfw.supabase.co
- MCP Server: http://127.0.0.1:8000
