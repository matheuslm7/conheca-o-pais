type Props = {
  label: string
  value: string
}

export function CountryDetail({ label, value }: Props) {
  return (
    <div className="flex justify-between gap-3 text-xs">
      <span className="text-muted">{label}</span>
      <span className="text-right font-medium text-ink">{value}</span>
    </div>
  )
}
