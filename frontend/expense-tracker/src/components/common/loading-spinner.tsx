import { cn } from "@/lib/utils"

interface SpinnerProps {
  size?: 'sm' | 'md' | 'lg'
  color?: 'primary' | 'secondary' | 'accent'
  className?: string
}

export function LoadingSpinner({ size = 'md', color = 'primary', className }: SpinnerProps) {
  const sizeClasses = {
    sm: 'w-5 h-5',
    md: 'w-8 h-8',
    lg: 'w-12 h-12'
  }

  const colorClasses = {
    primary: 'text-primary',
    secondary: 'text-secondary',
    accent: 'text-accent'
  }

  return (
    <div className={cn("relative", sizeClasses[size], className)} aria-label="Loading">
      <div className={cn("animate-spin rounded-full border-2 border-current border-t-transparent", colorClasses[color])} style={{width: '100%', height: '100%'}}></div>
    </div>
  )
}

