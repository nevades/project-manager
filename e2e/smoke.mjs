/**
 * End-to-end smoke test: drives a real Chromium browser through the main user journeys.
 *
 * Expects a fresh stack started with demo data (`docker compose up --build`). Usage:
 *   cd e2e && npm install && npx playwright install chromium && npm test
 *
 * BASE_URL defaults to http://localhost:8080. Screenshots are written to SCREENSHOT_DIR (default ./screenshots).
 */
import { mkdirSync } from 'node:fs'
import { chromium } from 'playwright'

const BASE = process.env.BASE_URL ?? 'http://localhost:8080'
const OUT = process.env.SCREENSHOT_DIR ?? 'screenshots'
mkdirSync(OUT, { recursive: true })
const results = []
const consoleErrors = []

function check(name, ok, detail = '') {
  results.push({ name, ok, detail })
  console.log(`${ok ? 'PASS' : 'FAIL'}  ${name}${detail ? '  -- ' + detail : ''}`)
}

async function step(name, fn) {
  try {
    await fn()
    check(name, true)
  } catch (error) {
    check(name, false, String(error.message ?? error).split('\n')[0])
    await page.screenshot({ path: `${OUT}/fail-${results.length}.png` }).catch(() => {})
    // Leave no dialog open so one failure does not cascade into the next step.
    await page.keyboard.press('Escape').catch(() => {})
    await page.keyboard.press('Escape').catch(() => {})
  }
}

async function drag(page, source, target) {
  const s = await source.boundingBox()
  const t = await target.boundingBox()
  await page.mouse.move(s.x + s.width / 2, s.y + s.height / 2)
  await page.mouse.down()
  await page.mouse.move(s.x + s.width / 2 + 10, s.y + s.height / 2 + 10, { steps: 5 })
  await page.mouse.move(t.x + t.width / 2, t.y + 60, { steps: 25 })
  await page.waitForTimeout(150)
  await page.mouse.up()
}

const browser = await chromium.launch()
const context = await browser.newContext({ viewport: { width: 1440, height: 900 } })
const page = await context.newPage()
page.on('console', (msg) => msg.type() === 'error' && consoleErrors.push(msg.text()))
page.on('pageerror', (err) => consoleErrors.push(String(err)))
page.setDefaultTimeout(10_000)

await step('unauthenticated visit redirects to /login', async () => {
  await page.goto(BASE + '/boards/1')
  await page.waitForURL('**/login')
  await page.screenshot({ path: `${OUT}/01-login.png` })
})

await step('wrong password shows an error', async () => {
  await page.getByLabel('Email').fill('demo@example.com')
  await page.getByLabel('Password').fill('wrong-password')
  await page.getByRole('button', { name: 'Sign in', exact: true }).click()
  await page.getByRole('alert').filter({ hasText: 'Invalid email or password' }).waitFor()
})

await step('demo login lands on boards overview', async () => {
  await page.getByRole('button', { name: 'Explore the demo workspace' }).click()
  await page.getByRole('heading', { name: 'Hi, Demo' }).waitFor()
  await page.getByText('Website Relaunch').first().waitFor()
  await page.screenshot({ path: `${OUT}/02-boards.png` })
})

await step('board opens with lists and cards', async () => {
  await page.getByRole('link', { name: /Website Relaunch/ }).first().click()
  await page.locator('section[aria-label="List: To do"]').waitFor()
  const lists = await page.locator('section[aria-label^="List: "]').count()
  if (lists !== 5) throw new Error(`expected 5 lists, got ${lists}`)
  await page.screenshot({ path: `${OUT}/03-board.png` })
})

await step('drag card to another list persists after reload', async () => {
  const card = page.getByLabel('Card: Design hero section')
  const target = page.locator('section[aria-label="List: Review"]')
  await drag(page, card, target)
  await page.waitForLoadState('networkidle')
  await target.getByLabel('Card: Design hero section').waitFor()
  await page.reload()
  await page.locator('section[aria-label="List: Review"]').getByLabel('Card: Design hero section').waitFor()
})

await step('drag list to reorder persists after reload', async () => {
  const header = page.locator('section[aria-label="List: Done"] header')
  const target = page.locator('section[aria-label="List: Backlog"]')
  await drag(page, header, target)
  await page.waitForLoadState('networkidle')
  await page.reload()
  await page.locator('section[aria-label="List: Done"]').waitFor()
  const first = await page.locator('section[aria-label^="List: "]').first().getAttribute('aria-label')
  if (first !== 'List: Done') throw new Error(`first list is ${first}`)
})

await step('add a card', async () => {
  const list = page.locator('section[aria-label="List: To do"]')
  await list.getByRole('button', { name: 'Add a card' }).click()
  await list.getByPlaceholder('Enter a title for this card…').fill('E2E created card')
  await list.getByPlaceholder('Enter a title for this card…').press('Enter')
  await list.getByLabel('Card: E2E created card').waitFor()
  await list.getByPlaceholder('Enter a title for this card…').press('Escape')
})

await step('add a list', async () => {
  await page.getByRole('button', { name: 'Add another list' }).click()
  await page.getByPlaceholder('List name').fill('QA')
  await page.getByRole('button', { name: 'Add list' }).click()
  await page.locator('section[aria-label="List: QA"]').waitFor()
  await page.getByPlaceholder('List name').press('Escape')
})

await step('card modal: description, priority, label, checklist, comment', async () => {
  await page.getByLabel('Card: E2E created card').click()
  await page.getByRole('dialog').waitFor()
  await page.getByRole('button', { name: 'Add a more detailed description…' }).click()
  await page.getByPlaceholder('Add a more detailed description…').fill('Written by the end-to-end test.')
  await page.getByRole('button', { name: 'Save', exact: true }).click()
  await page.getByText('Written by the end-to-end test.').waitFor()
  await page.locator('#card-priority').selectOption('HIGH')
  await page.getByText('High priority').waitFor()
  await page.locator('#card-assignee').selectOption({ label: 'Alex Rivera' })
  await page.getByRole('dialog').getByRole('button', { name: 'Bug', exact: true }).click()
  await page.getByLabel('New checklist item').fill('First step')
  await page.getByRole('button', { name: 'Add', exact: true }).click()
  await page.getByRole('checkbox', { name: 'First step' }).click()
  await page.waitForFunction(() => document.querySelector('input[aria-label="First step"]')?.checked === true)
  await page.getByLabel('Write a comment').fill('Looks good from the E2E test')
  await page.getByRole('button', { name: 'Comment', exact: true }).click()
  await page.getByText('Looks good from the E2E test').waitFor()
  await page.waitForLoadState('networkidle')
  await page.screenshot({ path: `${OUT}/04-card-modal.png` })
  await page.keyboard.press('Escape')
  await page.getByRole('dialog').waitFor({ state: 'detached' })
})

await step('rapid edits are all saved (assignee + label + priority survive reload)', async () => {
  await page.reload()
  await page.getByLabel('Card: E2E created card').click()
  await page.getByRole('dialog').getByText('Written by the end-to-end test.').waitFor()
  const assignee = await page.locator('#card-assignee option:checked').textContent()
  const priority = await page.locator('#card-priority').inputValue()
  const bug = await page.getByRole('dialog').getByRole('button', { name: 'Bug', exact: true }).getAttribute('aria-pressed')
  if (assignee !== 'Alex Rivera' || priority !== 'HIGH' || bug !== 'true') {
    throw new Error(`assignee=${assignee} priority=${priority} bug=${bug}`)
  }
  await page.keyboard.press('Escape')
  await page.getByRole('dialog').waitFor({ state: 'detached' })
})

await step('card badges reflect edits', async () => {
  const card = page.getByLabel('Card: E2E created card')
  await card.getByText('High').waitFor()
  await card.getByText('1/1').waitFor()
  await card.getByText('Bug').waitFor()
  await page.screenshot({ path: `${OUT}/05-board-after-edits.png` })
})

await step('card deep link opens modal', async () => {
  const url = page.url()
  await page.getByLabel('Card: E2E created card').click()
  await page.waitForURL(/card=\d+/)
  const deep = page.url()
  await page.goto(deep)
  await page.getByRole('dialog').getByText('Written by the end-to-end test.').waitFor()
  await page.keyboard.press('Escape')
  await page.goto(url)
})

await step('filter cards by text', async () => {
  await page.getByPlaceholder('Filter cards…').fill('navigation')
  await page.getByLabel('Card: Build responsive navigation').waitFor()
  const visible = await page.locator('[aria-label^="Card: "]').count()
  if (visible !== 1) throw new Error(`expected 1 visible card, got ${visible}`)
  await page.getByPlaceholder('Filter cards…').fill('')
})

await step('board settings: create label', async () => {
  await page.getByRole('button', { name: 'Board settings' }).click()
  await page.getByRole('tab', { name: 'Labels' }).click()
  await page.getByLabel('Label name').fill('E2E label')
  await page.getByRole('button', { name: 'Create', exact: true }).click()
  await page.getByRole('dialog').getByText('E2E label').waitFor()
  await page.getByRole('tab', { name: 'Members' }).click()
  await page.getByText('Sam Patel').waitFor()
  await page.screenshot({ path: `${OUT}/06-settings.png` })
  await page.keyboard.press('Escape')
})

await step('create a new board from overview', async () => {
  await page.goto(BASE + '/')
  await page.getByRole('button', { name: 'New board' }).click()
  await page.getByLabel('Board name').fill('E2E Board')
  await page.getByRole('radio', { name: 'Forest' }).click()
  await page.getByRole('button', { name: 'Create board' }).click()
  await page.waitForURL(/\/boards\/\d+/)
  await page.locator('section[aria-label="List: In progress"]').waitFor()
})

await step('admin page lists users', async () => {
  await page.goto(BASE + '/admin')
  await page.getByRole('heading', { name: 'User management' }).waitFor()
  await page.locator('tbody tr').first().waitFor()
  const rows = await page.locator('tbody tr').count()
  if (rows !== 3) throw new Error(`expected 3 users, got ${rows}`)
  await page.screenshot({ path: `${OUT}/07-admin.png` })
})

await step('sign out returns to login', async () => {
  await page.getByRole('button', { name: 'Account menu' }).click()
  await page.getByRole('menuitem', { name: 'Sign out' }).click()
  await page.waitForURL('**/login')
  await page.goto(BASE + '/')
  await page.waitForURL('**/login')
})

await step('register a new account', async () => {
  await page.getByRole('link', { name: 'Create an account' }).click()
  await page.getByLabel('Full name').fill('Erin Tester')
  await page.getByLabel('Email').fill('erin@example.com')
  await page.getByLabel('Password').fill('supersecret1')
  await page.getByRole('button', { name: 'Create account' }).click()
  await page.getByRole('heading', { name: 'Hi, Erin' }).waitFor()
  const adminLink = await page.getByRole('link', { name: 'Admin' }).count()
  if (adminLink !== 0) throw new Error('new user should not see Admin')
})

await step('new user cannot open demo board', async () => {
  await page.goto(BASE + '/boards/1')
  await page.getByText('Board not available').waitFor()
})

await step('mobile layout renders board', async () => {
  const mobile = await browser.newContext({ viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true })
  const m = await mobile.newPage()
  await m.goto(BASE + '/login')
  await m.getByRole('button', { name: 'Explore the demo workspace' }).click()
  await m.getByRole('heading', { name: 'Hi, Demo' }).waitFor()
  await m.screenshot({ path: `${OUT}/08-mobile-boards.png` })
  await m.getByRole('link', { name: /Website Relaunch/ }).first().click()
  await m.locator('section[aria-label^="List: "]').first().waitFor()
  await m.screenshot({ path: `${OUT}/09-mobile-board.png` })
  await mobile.close()
})

check('no console errors / CSP violations', consoleErrors.filter((e) => !/401|Failed to load resource/.test(e)).length === 0,
  consoleErrors.join(' | ').slice(0, 500))

await browser.close()
const failed = results.filter((r) => !r.ok).length
console.log(`\n${results.length - failed}/${results.length} checks passed`)
process.exit(failed ? 1 : 0)
